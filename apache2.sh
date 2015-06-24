#!/bin/bash
chmod -R 777 /etc/airtime
source /etc/apache2/envvars
exec apache2 -D FOREGROUND