# FROM postgis/postgis:14-3.2
# postgis does not have ARM64 images so we are building it
# using their source  (https://github.com/postgis/docker-postgis/tree/master/14-3.4)

# Begin postgis dockerfile

FROM postgres:14-bullseye

LABEL maintainer="PostGIS Project - https://postgis.net" \
      org.opencontainers.image.description="PostGIS 3.5.0+dfsg-1.pgdg110+1 spatial database extension with PostgreSQL 14 bullseye" \
      org.opencontainers.image.source="https://github.com/postgis/docker-postgis"

ENV POSTGIS_MAJOR 3
ENV POSTGIS_VERSION 3.5.0+dfsg-1.pgdg110+1

RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
           # ca-certificates: for accessing remote raster files;
           #   fix: https://github.com/postgis/docker-postgis/issues/307
           ca-certificates \
           \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh
COPY ./update-postgis.sh /usr/local/bin
# End postgis dockerfile

RUN apt-get update && apt-get install -y locales \
  && sed -i 's/^# tr_TR.UTF-8 UTF-8/tr_TR.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen tr_TR.UTF-8 \
  && update-locale LANG=tr_TR.UTF-8

ENV LANG tr_TR.UTF-8