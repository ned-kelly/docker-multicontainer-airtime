#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Install required dep's for airtime
apt-get update
apt-get install -y apache2 icecast2

# Install script expects 'airtime' to be the hostname of the container..
echo "127.0.0.1 airtime" >> /etc/hosts

source /etc/apache2/envvars
service apache2 start

# Remove pulsaudio: - http://sourcefabric.booktype.pro/airtime-25-for-broadcasters/preparing-the-server/
apt-get purge pulseaudio -y

# Multiverse requried for some pkgs...
sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list
apt-get update -y

## airtime use python, and the latest ubuntu build is breaking a few things... Here's a quick fix:
apt-get --fix-missing --reinstall install python python-minimal dh-python -y
apt-get -f install

mkdir -p /opt/airtime
curl -L https://github.com/sourcefabric/airtime/archive/airtime-2.5.2.1.tar.gz | tar --strip-components=1 -C /opt/airtime -xz
/opt/airtime/install --force --apache --icecast --in-place

# This will be mapped in with all the media...
mkdir -p /external-media/

# Permissions ...
chmod 777 /external-media/
chmod 777 -R /etc/airtime/

#chown -R www-data:www-data /external-media

#sudo cp ~/helpers/media /etc/airtime/media_monitor_logging.cfg

service apache2 restart
sleep 5

# Configure (This is the same as running in the web-ui)
IP=$(ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://')

# Database
curl -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
     -H 'Accept: application/json, text/javascript, */*; q=0.01' \
     --data 'dbUser=airtime&dbPass=airtime&dbName=airtime&dbHost=airtime-postgres&dbErr=' \
     "http://${IP}/setup/setup-functions.php?obj=DatabaseSetup"

# RabbitMQ
curl -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
     -H 'Accept: application/json, text/javascript, */*; q=0.01' \
     --data 'rmqUser=airtime&rmqPass=airtime&rmqHost=airtime-rabbitmq&rmqPort=5672&rmqVHost=/airtime&rmqErr=' \
     "http://${IP}/setup/setup-functions.php?obj=RabbitMQSetup"

# Web Interface
curl -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
     -H 'Accept: application/json, text/javascript, */*; q=0.01' \
     --data 'generalHost=localhost&generalPort=80&generalErr=' \
     "http://${IP}/setup/setup-functions.php?obj=GeneralSetup"

# Media Settings
curl -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
     -H 'Accept: application/json, text/javascript, */*; q=0.01' \
      --data 'mediaFolder=%2Fexternal-media%2F&mediaErr=' \
      "http://${IP}/setup/setup-functions.php?obj=MediaSetup"

### Now we can get rid of the components that were installed with Airtime that we're actually running in other docker containers...
service postgresql stop
apt-get remove postgresql-9.3 rabbitmq-server -y

sudo php5enmod opcache

# Status page check can be found at: http://localhost/?config

#service airtime-playout start
#service airtime-liquidsoap start
#service airtime-media-monitor start

#sudo cp ~/helpers/htaccess /opt/airtime/public/.htaccess

sudo apt-get clean
