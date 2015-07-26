
sudo apt-get update
sudo apt-get install -y rabbitmq-server apache2 curl supervisor
sudo source /etc/apache2/envvars
sudo service rabbitmq-server start
sudo service apache2 start

mkdir ~/airtime
curl -L https://github.com/sourcefabric/airtime/archive/2.5.x.tar.gz | tar --strip-components=1 -C ~/airtime -xz
~/airtime/install -fa
php5enmod opcache
rm -rf ~/airtime
