echo "127.0.0.1 airtime" >> /etc/hosts
locale-gen --purge en_US.UTF-8 && echo -e 'LANG="$LANG"\nLANGUAGE="$LANGUAGE"\n' > /etc/default/locale

adduser --disabled-password --gecos "" airtime
adduser airtime sudo
