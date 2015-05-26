#! /usr/bin/env bash

SETTINGS_MODULE=''
# specific config file handling
if [ -d /app/requirements ]; then
    cd /app && pip${PY_VERSION/\..*/} install --upgrade -r requirements/prod.txt
else
    pip${PY_VERSION/\..*/} install -r /app/requirements.txt
fi

# Setup the static files
if [ -f /app/manage.py ]; then
    if ! [ -d /staticfiles ]; then
        mkdir /staticfiles
    fi
    cd /app && python3 manage.py collectstatic --noinput
    SETTINGS_MODULE=$(grep SETTINGS /app/manage.py | awk -F',' '{print $2}' | \
        awk -F'"' '{print $2}')
    sed -i "s/SETTINGS_MODULE/$SETTINGS_MODULE/" /utils/django_start
else
    echo "No manage.py file found, stopping build..."
    exit 1
fi

# Removing useless packages
yum remove -y mpfr libmpc gcc cpp kernel-headers glibc-headers glibc-devel
echo "Setup done..."
