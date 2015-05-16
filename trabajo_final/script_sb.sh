#!/bin/bash

# Comprobación de permisos
user=$(whoami)
if [ "$user" == "root" ]; then
   esroot=true
else
   esroot=false
   echo "No eres root... :'(" 
   exit
fi

#Trabajamos en un directorio temporal
TEMPDIR=$(mktemp -d)
cd $TEMPDIR

IP_SERVIDOR=$(curl ifconfig.me)

# Repositorios necesarios
wget -t 5 http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list 

echo "deb http://dl.ajaxplorer.info/repos/apt stable main" >> /etc/apt/sources.list 
echo "deb-src http://dl.ajaxplorer.info/repos/apt stable main" >> /etc/apt/sources.list 
wget -O - http://dl.ajaxplorer.info/repos/charles@ajaxplorer.info.gpg.key | sudo apt-key add -

apt-get update

# Instalación Deluge					#####################################
apt-get --yes install python python-geoip python-libtorrent python-notify python-pygame python-gtk2 python-gtk2-dev python-twisted python-twisted-web2 python-openssl python-simplejson python-setuptools gettext python-xdg python-chardet librsvg2-dev xdg-utils python-mako

pkill deluge

wget -N --no-check-certificate http://download.deluge-torrent.org/source/deluge-1.3.6.tar.gz
tar xvfz deluge-1.3.6.tar.gz
rm deluge-1.3.6.tar.gz
cd deluge-1.3.6

python setup.py build
python setup.py install
ldconfig

deluge-console "config -s allow_remote True"
deluge-console "config allow_remote"

# ##########################			#####################################

# Instalación Webmin					#####################################
apt-get --yes install webmin

# ##########################			#####################################

# Instalación Pydio					#####################################
apt-get --yes install pydio
cp /usr/share/doc/pydio/apache2.sample.conf /etc/apache2/sites-available/pydio.conf
a2ensite pydio.conf
a2enmod rewrite

perl -pi -e "s/<servername>/$IP_SERVIDOR/g" /etc/apache2/sites-available/default
echo "ServerName $IP_SERVIDOR" | tee -a /etc/apache2/apache2.conf > /dev/null

# ##########################			#####################################

# Instalacion mysql
apt-get --yes install mysql-server libapache2-mod-auth-mysql php5-mysql
mysql_install_db
mysql 
echo 'CREATE DATABASE pydio;' | mysql
echo "CREATE USER pydio@localhost IDENTIFIED BY 'password';" | mysql
echo "GRANT ALL PRIVILEGES ON pydio . * TO pydio@localhost;" | mysql


# Inicio de los servicios:
deluged
deluge-web --fork
service apache2 restart

echo -e "\n\n\n\n\n\nAcceso Deluge web: http://$IP_SERVIDOR:8112 (pass: deluge)"
echo "Pydio: http://$IP_SERVIDOR/pydio/index.php"
echo "Webmin http://$IP_SERVIDOR:10000"
