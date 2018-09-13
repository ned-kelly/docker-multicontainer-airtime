FROM ubuntu:trusty

ENV HOSTNAME airtime

## General components we need in this container...
RUN apt-get clean && apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y locales sudo htop nano curl wget supervisor

COPY bootstrap/bootstrap.sh /opt/airtime/bootstrap.sh
COPY minimal.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /opt/airtime/bootstrap.sh && \
    mkdir /opt/airtime/helpers

COPY fixes /opt/airtime/helpers
RUN /opt/airtime/bootstrap.sh

VOLUME ["/etc/airtime", "/var/tmp/airtime/", "/var/log/airtime", "/usr/share/airtime", "/usr/lib/airtime"]
VOLUME ["/var/tmp/airtime"]

VOLUME ["/var/log/icecast2", "/etc/icecast2"]

EXPOSE 80 8000

CMD ["/usr/bin/supervisord"]
