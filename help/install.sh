

sudo source /etc/apache2/envvars
sudo service rabbitmq-server start
sudo service apache2 start

sudo cp ~/helpers/htaccess /usr/share/airtime/public/.htaccess

mkdir ~/airtime
curl -L https://github.com/sourcefabric/airtime/archive/2.5.x.tar.gz | tar --strip-components=1 -C ~/airtime -xz
sudo ~/airtime/install -fa
sudo php5enmod opcache
rm -rf ~/airtime
