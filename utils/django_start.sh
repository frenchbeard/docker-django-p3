#! /usr/bin/env bash

GUNICORN=$(which gunicorn 2> /dev/null)
UWSGI=$(which uwsgi 2> /dev/null)
NAME=${APP_NAME:-default}
NUM_WORKERS=3
SETTINGS=SETTINGS_MODULE
SETTINGS_PATH="/app/${SETTINGS//\.//}.py"

DB_ENGINE=${DB_ENGINE:-"django.db.backends.postgresql_psycopg2"}
DB_NAME=${DB_NAME:-"db_name"}
DB_USER=${DB_USER:-"db_user"}
DB_PASS=${DB_PASS:-"db_password"}
DB_HOST=${DB_HOST:-"localhost"}
DB_PORT=${DB_PORT:-""}

#Setting up db in config file
sed -i "s/'ENGINE'.*/'ENGINE': '$DB_ENGINE',/" $SETTINGS_PATH
sed -i "s/'NAME': '.*/'NAME': '$DB_NAME',/" $SETTINGS_PATH
sed -i "s/'USER'.*/'USER': '$DB_USER',/" $SETTINGS_PATH
sed -i "s/'PASSWORD'.*/'PASSWORD': '$DB_PASS',/" $SETTINGS_PATH
sed -i "s/'HOST'.*/'HOST': '$DB_HOST',/" $SETTINGS_PATH
sed -i "s/'PORT'.*/'PORT': '$DB_PORT',/" $SETTINGS_PATH

sleep 20

cd /app && python3 manage.py migrate

# Start your Django Gunicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
if [ $GUNICORN ]; then
    echo -e "Launching $NAME on gunicorn..."
    cd /app && \
    exec /bin/gunicorn \
      --workers $NUM_WORKERS \
      --bind=0.0.0.0:8000 \
      $NAME.wsgi
elif [ $UWSGI ]; then
    echo -e "Launching $NAME on uwsgi..."
else
    echo -e "No production wsgi server found, stopping setup..."
    exit 1
fi
