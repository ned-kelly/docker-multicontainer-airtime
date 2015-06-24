FROM ubuntu:15.04

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
ENV HOSTNAME airtime

MAINTAINER Víctor Rojas <okvic77@me.com>
COPY apache2.sh /boot-apache2.sh
COPY pre.sh /pre.sh
#COPY config.php /generate-config-tmp.php

RUN /pre.sh


#RUN /generate-config-tmp.php
# docker run -p 80:80 -it --name airtime -e LANG=en_US.UTF-8 -e LANGUAGE=en_US:en -e LC_ALL=en_US.UTF-8 -e HOSTNAME=airtime ubuntu:15.04 /bin/bash
EXPOSE 80
CMD /boot-apache2.sh