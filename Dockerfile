FROM centos:6.10

COPY ./nutcracker-0.4.0.tar.gz /opt/nutcracker-0.4.0.tar.gz

RUN yum install -y gcc

RUN cd /opt \
    && tar zxf nutcracker-0.4.0.tar.gz \
    && cd nutcracker-0.4.0 \
    && ./configure \
    && make \
    && make install

RUN mkdir /etc/nutcracker \
    && cp /opt/nutcracker-0.4.0/scripts/nutcracker.init /etc/init.d/nutcracker \
    && chmod +x /etc/init.d/nutcracker

COPY conf/nutcracker.yml /etc/nutcracker/nutcracker.yml

RUN touch /var/log/nutcracker.log \
    && chgrp nobody /var/log/nutcracker.log \
    && chmod 664 /var/log/nutcracker.log

RUN rm -rf /opt/nutcracker-0.4.0 \
    && yum remove -y gcc \
    && yum clean all

CMD ["nutcracker", "-c", "/etc/nutcracker.conf"]
