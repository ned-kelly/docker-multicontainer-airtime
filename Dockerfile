FROM ubuntu:latest

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV HOSTNAME airtime

MAINTAINER Víctor Rojas <okvic77@me.com>
COPY help/pre.sh /pre.sh
RUN /pre.sh




COPY alone.conf /etc/supervisor/conf.d/supervisord.conf
COPY help/install.sh /home/airtime/install.sh
RUN chmod +x /home/airtime/install.sh && chown airtime /home/airtime/install.sh && mkdir /home/airtime/helpers

USER airtime
COPY fixes /home/airtime/helpers
RUN /home/airtime/install.sh







VOLUME ["/srv/airtime/stor/", "/etc/airtime", "/var/tmp/airtime/", "/var/log/airtime", "/usr/share/airtime", "/usr/lib/airtime", "/var/lib/mysql"]
EXPOSE 80

USER root

CMD ["/usr/bin/supervisord"]
