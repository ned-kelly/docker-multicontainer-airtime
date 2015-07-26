


sudo service rabbitmq-server start
sudo source /etc/apache2/envvars
sudo service apache2 start

mkdir ~/airtime
curl -L https://github.com/sourcefabric/airtime/archive/2.5.x.tar.gz | tar --strip-components=1 -C ~/airtime -xz
sudo ~/airtime/install -fapi

sudo mkdir -p /srv/airtime/stor
sudo chown -R airtime:www-data /srv/airtime/stor/


sudo cp ~/helpers/htaccess /usr/share/airtime/public/.htaccess
sudo cp ~/helpers/config /etc/airtime/airtime.conf
#sudo cp ~/helpers/media /etc/airtime/media_monitor_logging.cfg


sudo php5enmod opcache
sudo rm -rf ~/airtime
