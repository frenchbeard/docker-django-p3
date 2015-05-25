#! /usr/bin/env bash

cd /app \
&& ./manage.py migrate \
&& exec manage.py runserver 80

# if [ $uwsgi ]; then
#     echo "Launching uwsgi..."
# elif [ $gunicorn ]; then
#     echo "Launching gunicorn..."
# else
# fi
