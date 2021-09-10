FROM python:3.9.0-alpine

ENV APP_PORT=3735
ENV ADMIN_USER=admin
ENV ADMIN_PASSWORD=password
ENV ADMIN_EMAIL=admin@localhost

ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

WORKDIR /app

COPY ./requirements.txt requirements.txt
RUN set -ex ;\
    apk add libpq postgresql-dev --virtual .build-deps coreutils gcc libc-dev libffi-dev make ;\
    pip install -U pip ;\
    pip install --no-cache-dir --progress-bar off -r requirements.txt ;\
    apk del .build-deps make gcc coreutils ;\
    rm -rf /root/.cache


RUN set -ex ;\
    mkdir -p /data/static /data/media ;\
    mkdir -p /etc/etebase-server
    
COPY ./etebase-server.ini /etc/etebase-server
COPY . /app

VOLUME /data
EXPOSE $APP_PORT

RUN chmod +x /app/entrypoint.sh

CMD ["sh", "-c", "/app/entrypoint.sh $APP_PORT $ADMIN_USER $ADMIN_EMAIL $ADMIN_PASSWORD"]