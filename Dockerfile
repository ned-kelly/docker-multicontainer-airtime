FROM ubuntu:15.04

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
ENV HOSTNAME airtime

MAINTAINER Víctor Rojas <okvic77@me.com>
COPY help /help
RUN /help/pre.sh

VOLUME ["/srv/airtime/stor/", "/etc/airtime/", "/var/tmp/airtime/", "/var/log/airtime", "/usr/share/airtime"]

# docker run -p 80:80 -it --name airtime -e LANG=en_US.UTF-8 -e LANGUAGE=en_US:en -e LC_ALL=en_US.UTF-8 -e HOSTNAME=airtime ubuntu:15.04 /bin/bash
EXPOSE 80
CMD /help/apache2.sh