# docker-django-p3

A dockerfile to build a basic django environment on a centos image.
Contains up-to-date repository (iuscommunity) for development packages, as well as latest EPEL.
The django development server has been replaced with Gunicorn.
All of that being in python3, so please check your requirements.txt for compatibility
It will not work with PyPi packages unsupported by python3.

## Building the image

to create the image :
```
docker build -t $USER/django-gunicorn-python3.
```

