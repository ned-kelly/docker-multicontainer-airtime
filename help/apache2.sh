#!/bin/bash

php /help/config.php
#service airtime-media-monitor start && service airtime-playout restart && service airtime-liquidsoap restart && tail -f /var/log/airtime/media-monitor/media-monitor.log
source /etc/apache2/envvars
exec apache2 -D FOREGROUND