FROM ubuntu:trusty

## General components we need in this container...
RUN apt-get clean && apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y locales sudo htop nano curl wget supervisor

COPY bootstrap/entrypoint.sh /opt/airtime/entrypoint.sh
COPY bootstrap/bootstrap.sh /opt/airtime/bootstrap.sh
COPY config/supervisor-minimal.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /opt/airtime/bootstrap.sh && \
    chmod +x /opt/airtime/entrypoint.sh && \
    mkdir /opt/airtime/helpers

COPY fixes /opt/airtime/helpers

# This is now run as part of the CMD when the container starts for the first time...
# RUN /opt/airtime/bootstrap.sh

VOLUME ["/etc/airtime", "/var/tmp/airtime/", "/var/log/airtime", "/usr/share/airtime", "/usr/lib/airtime"]
VOLUME ["/var/tmp/airtime"]

VOLUME ["/var/log/icecast2", "/etc/icecast2"]

EXPOSE 80 8000

CMD ["/opt/airtime/entrypoint.sh"]
#CMD ["/usr/bin/supervisord"]
