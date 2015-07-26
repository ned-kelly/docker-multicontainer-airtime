echo "127.0.0.1 airtime" >> /etc/hosts
locale-gen --purge en_US.UTF-8 && echo -e 'LANG="$LANG"\nLANGUAGE="$LANGUAGE"\n' > /etc/default/locale
echo "airtime   ALL=(ALL:ALL) ALL" >> /etc/sudoers
adduser --disabled-password --gecos "" airtime
apt-get update
apt-get install -y rabbitmq-server apache2 curl supervisor
