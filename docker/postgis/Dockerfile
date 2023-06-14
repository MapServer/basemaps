FROM ghcr.io/camptocamp/postgres:14-postgis-3

ARG USER_ID=1000

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sudo

RUN groupadd nopwsudo \
    && echo "%nopwsudo      ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/nopwsudo \
    && useradd mapserveruser -u ${USER_ID} -G nopwsudo,sudo,adm -m

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git make build-essential python wget unzip mapserver-bin cgi-mapserver

RUN mkdir /app \
    && chown -R mapserveruser /app    

# install imposm3
RUN wget -O imposm3.tgz 'https://github.com/omniscale/imposm3/releases/download/v0.6.0-alpha.4/imposm-0.6.0-alpha.4-linux-x86-64.tar.gz'
RUN tar --strip-components 1 -xzf imposm3.tgz -C /opt
RUN ln -s  /opt/imposm /usr/local/bin/imposm

ADD initdb.sh /docker-entrypoint-initdb.d/initdb.sh

WORKDIR /app

ENV POSTGRES_USER osm
