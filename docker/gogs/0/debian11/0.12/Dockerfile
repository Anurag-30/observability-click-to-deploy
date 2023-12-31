FROM marketplace.gcr.io/google/debian11:latest

ENV GOGS_CUSTOM /data/gogs
ENV GOGS_DB_TYPE sqlite3
ENV GOGS_DB_HOST 127.0.0.1:3306
ENV GOGS_DB_NAME gogs
ENV GOGS_DB_USER root
ENV GOGS_DB_PASSWORD ${1:+1}
ENV GOGS_SECRET_KEY ChangeMe
ENV GOGS_DOMAIN localhost
ENV GOGS_EXTERNAL_URL http://localhost:3000/

WORKDIR /app/gogs

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl git ca-certificates rsync sqlite3 gettext-base jq \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV GOGS_VERSION 0.12.10
ARG GOGS_DIST=https://github.com/gogs/gogs/releases/download/v${GOGS_VERSION}/gogs_${GOGS_VERSION}_linux_amd64.tar.gz
ADD $GOGS_DIST /tmp/gogs.tar.gz
RUN (tar -xvf /tmp/gogs.tar.gz -C /app/ && rm /tmp/gogs.tar.gz) || true

COPY app.ini.env /app/gogs/
COPY entrypoint.sh run_test.sh /usr/local/bin/

RUN groupadd -g 1000 git && useradd -m -u 1000 -g git -m -s /bin/bash -d /data/git git

RUN mkdir -p /data/gogs/data \
    && mkdir /data/gogs/conf \
    && mkdir /data/gogs/logs \
    && mkdir /data/git/gogs-repositories \ 
    && chown -R git:git /data

USER git

ENV C2D_RELEASE 0.12.10

VOLUME ["/data", "/backup"]
EXPOSE 22 3000

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD [ "/app/gogs/gogs", "web" ]
