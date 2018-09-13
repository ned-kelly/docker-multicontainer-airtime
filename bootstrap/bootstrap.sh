#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Install required dep's for airtime
apt-get update
apt-get install -y apache2 icecast2 rabbitmq-server git

# Install script expects 'airtime' to be the hostname of the container..
echo "127.0.0.1 airtime" >> /etc/hosts

source /etc/apache2/envvars
service apache2 start
service rabbitmq-server start

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
/opt/airtime/install --force --apache --postgres --icecast

# This will be mapped in with all the media...
mkdir -p /external-media/

# Permissions ...
chmod 777 /external-media/
chmod 777 -R /etc/airtime/

#chown -R www-data:www-data /external-media

#sudo cp ~/helpers/media /etc/airtime/media_monitor_logging.cfg

sudo service apache2 restart
sudo service postgresql restart

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
service rabbitmq-server stop
service icecast2 stop
service apache2 stop

apt-get remove rabbitmq-server postgresql-9.3 -y

sudo php5enmod opcache

# There seems to be a bug somewhere in the code and it's not respecting the DB being on another host (even though it's configured in the config files!)
# We'll use a lightweight golang TCP proxy to proxy any PGSQL request to the postgres docker container on TCP:5432. 

cd /opt/ && wget https://dl.google.com/go/go1.10.1.linux-amd64.tar.gz
tar -xzf go*
mv go /usr/local/

export GOPATH=/opt/
export GOROOT=/usr/local/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

go get github.com/jpillora/go-tcp-proxy/cmd/tcp-proxy
# Status page check can be found at: http://localhost/?config

#service airtime-playout start
#service airtime-liquidsoap start
#service airtime-media-monitor start

#sudo cp ~/helpers/htaccess /opt/airtime/public/.htaccess
sudo apt-get clean

# Now fire up supervisor and we're good to go!
/usr/bin/supervisord