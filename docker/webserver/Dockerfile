FROM debian:bookworm

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    mapserver-bin cgi-mapserver apache2  libapache2-mod-fcgid \
    git make build-essential python3 wget unzip 

RUN a2enmod alias fcgid cgid

ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

WORKDIR /app    

CMD ["/run-httpd.sh"]    
