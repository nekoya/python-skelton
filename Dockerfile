FROM python:3.6-alpine
WORKDIR /python

COPY requirements.txt .
COPY requirements-dev.txt .
COPY constraints.txt .
RUN \
 apk add --no-cache --virtual .dev-deps gcc musl-dev && \
#  apk add --no-cache --virtual .mysql-deps mariadb-dev && \
 pip install -r requirements.txt -c constraints.txt && \
 pip install -r requirements-dev.txt -c constraints.txt && \
 apk del --purge .dev-deps

COPY foo foo
