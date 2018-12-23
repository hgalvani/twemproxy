FROM debian:8.11

ENV TWEMPROXY_URL https://github.com/twitter/twemproxy/archive
ENV NUTCRACKER_VERSION v0.4.0
ENV NUTCRAKER_REP twemproxy-$NUTCRACKER_VERSION

RUN export DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    &&  apt-get -y install --no-install-recommend apt-utils 

RUN apt-get -y install build-essential gcc automake libtool curl

RUN apt-get -y install linux-headers-$(uname -r)

RUN curl -SL $TWEMPROXY_URL/$NUTCRACKER_VERSION.tar.gz \
    | tar xzf - \
    && cd twemproxy-0.4.0 \
    && autoscan \
    && ./configure \
    && make \
    && make install

RUN mkdir /etc/nutcracker \
    && cp /opt/twemproxy-0.4.0/scripts/nutcracker.init /etc/init.d/nutcracker \
    && chmod +x /etc/init.d/nutcracker

COPY conf/nutcracker.yml /etc/nutcracker/nutcracker.yml

RUN touch /var/log/nutcracker.log \
    && chgrp nobody /var/log/nutcracker.log \
    && chmod 664 /var/log/nutcracker.log

CMD ["nutcracker", "-c", "/etc/nutcracker.conf"]
