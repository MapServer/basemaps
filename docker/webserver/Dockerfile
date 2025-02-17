FROM camptocamp/mapserver:8.4-gdal3.10

RUN apt-get update && \
	apt-get install --assume-yes --no-install-recommends git make python3 gcc curl unzip wget

RUN git clone https://github.com/mapserver/basemaps.git /etc/mapserver && \
    cd /etc/mapserver && \
    git checkout 733bf56dc9e13eac53a1462fd2db563382d8dc0f && \
    chown -R www-data /etc/mapserver && \
    chmod -R g+w /etc/mapserver

RUN make -C /etc/mapserver/ data

VOLUME /etc/mapserver/data

COPY docker-entrypoint.sh /
COPY epsg /etc/mapserver/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/bin/start-server"]

ENV STYLE=google
