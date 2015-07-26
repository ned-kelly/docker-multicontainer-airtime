FROM ubuntu:latest

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV HOSTNAME airtime

MAINTAINER Víctor Rojas <okvic77@me.com>
COPY help/pre.sh /pre.sh
RUN /pre.sh

COPY help/install.sh /home/airtime/install.sh
RUN chmod +x /home/airtime/install.sh && chown airtime /home/airtime/install.sh
RUN su airtime -c "/home/airtime/install.sh"

COPY alone.conf /etc/supervisor/conf.d/supervisord.conf


COPY fixes/htaccess /usr/share/airtime/public/.htaccess


VOLUME ["/srv/airtime/stor/", "/etc/airtime", "/var/tmp/airtime/", "/var/log/airtime", "/usr/share/airtime", "/usr/lib/airtime", "/var/lib/mysql"]
EXPOSE 80



CMD ["/usr/bin/supervisord"]
