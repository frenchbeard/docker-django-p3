FROM frenchbeard/centos-dev

MAINTAINER frenchbeard <frenchbeardsec@gmail.com>

ENV DJ_VERSION  1.7.4
ENV PY_VERSION  3.4

RUN yum update -y \
    && yum install -y python34u-setuptools git gcc sqlite libpqxx-devel python34u-devel \
    && pip3 install --upgrade pip


COPY app/ /app/
ADD utils/django_setup.sh   /utils/django_setup
ADD utils/django_start.sh   /utils/django_start
RUN chmod 700 /utils/django_setup \
    && /utils/django_setup
RUN chmod 700 /utils/django_start

VOLUME ["/staticfiles"]

EXPOSE 8000

CMD ["/utils/django_start"]
