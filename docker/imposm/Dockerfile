FROM kartoza/docker-osm:imposm-latest

RUN mkdir /settings && \
    wget https://raw.githubusercontent.com/mapserver/basemaps/70026961c1b1c3e1d16ba605a95f66369b2369e2/imposm3-mapping.json -O /settings/basemaps-mapping.json

RUN mkdir /data && chmod o+w /data

COPY import.sh /usr/bin/
RUN chmod a+x /usr/bin/import.sh
CMD import.sh
