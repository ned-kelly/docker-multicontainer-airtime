


sudo service rabbitmq-server start


mkdir ~/airtime
curl -L https://github.com/sourcefabric/airtime/archive/2.5.x.tar.gz | tar --strip-components=1 -C ~/airtime -xz
sudo ~/airtime/install -fapi

sudo chown -R airtime:www-data .

sudo cp ~/helpers/htaccess /usr/share/airtime/public/.htaccess
sudo php5enmod opcache
sudo rm -rf ~/airtime
