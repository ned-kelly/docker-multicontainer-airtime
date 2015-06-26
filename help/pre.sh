echo "127.0.0.1 airtime" >> /etc/hosts
locale-gen --purge en_US.UTF-8 && echo -e 'LANG="$LANG"\nLANGUAGE="$LANGUAGE"\n' > /etc/default/locale
apt-get update
apt-get install -y rabbitmq-server apache2 curl
source /etc/apache2/envvars
service rabbitmq-server start
service apache2 start


mkdir /airtime
curl -L https://github.com/sourcefabric/airtime/archive/2.5.x.tar.gz | tar --strip-components=1 -C /airtime -xz
/airtime/install -fa
php5enmod opcache
rm -rf /airtime