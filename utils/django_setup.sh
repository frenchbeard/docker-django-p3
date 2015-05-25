#! /usr/bin/env bash

# specific config file handling
if [ -d /app/requirements ]; then
    cd /app && pip${PY_VERSION/\..*//} install --upgrade -r requirements/prod.txt
else
    pip${PY_VERSION/\..*//} install -r /app/requirements.txt
fi

# Setup the static files
if [ -f /app/manage.py ]; then
    if ! [ -d /staticfiles ]; then
        mkdir /staticfiles
    fi
    cd /app && python3 manage.py collectstatic --noinput
else
    echo "No manage.py file found, stopping build..."
    exit 1
fi

# Removing useless packages
yum remove -y mpfr libmpc gcc cpp kernel-headers glibc-headers glibc-devel
echo "Setup done..."
