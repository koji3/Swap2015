# SeedBox personal opensource
## Introducción

A lo largo de este trabajo se va a configurar un servidor virtual VPS para que trabaje como SeedBox de Torrents, esto es, un cliente torrent conectado las 24 horas del día con el ancho de banda propio de un centro de datos, por unos pocos euros al mes y utilizando solamente software open source.

Entre las ventajas que encontramos en estos sistemas tenemos:

 - **Velocidad de descarga:** La consecuencia directa del ancho de banda es la velocidad de descarga que, en torrents con suficientes seeders, es muy superior a la que se podría alcanzar con una conexión doméstica. Además, no sufriremos ningún descenso de velocidad en nuestro pc mientras descargamos.
 - **Online 24x7:** Al tener nuestro Seedbox conectado permanentemente, también es útil para archivos que descargan lento. Ya no es necesario dejar el ordenador encendido días enteros.
 - **Buena posición en los rankings de los trackers privados:** A la vez que descargas, estás compartiendo a otros por lo que tu reputación subirá. Esto se traduce en mayor velocidad de descarga.
 - **Self hosted:**  Al ser tu el único usuario del sistema no tienes que compartir los recursos con nadie.

También presenta algunos problemas que hay que intentar minimizar:

 - **Acceso rápido a los archivos descargados:** De nada vale descargar tan rápido en un servidor si el acceso a esos archivos es lento o tedioso.
 - **Disponibilidad:** Hay que conseguir que nuestra aplicación esté offline el menor tiempo posible.

Todo el trabajo está orientado a explicar como instalar tu propio SeedBox, resaltando las cosas mas importantes a tener en cuenta y mostrando los códigos que es necesario ejecutar . Al final se proporciona un script que automatiza todo el proceso.

## Punto de partida

La elección del proveedor de VPS depende de las necesidades que tengamos. Esta demostración se va a realizar en un VPS de DigitalOcean.com, que por 5$ mensuales nos ofrece unas características mas que suficientes. El sistema operativo será un **Ubuntu 12.04**.
Para crear nuestro servidor virtual nos registramos en DigitalOcean y vamos a la sección "Create Droplet":

![enter image description here](http://i.imgur.com/4N1zh6N.png)

Elegimos un nombre para el nuevo servidor, seleccionamos el tamaño que necesitemos y el sistema operativo, Ubuntu 12.04. Luego basta con darle a "Create" y esperar a que nos envíen la IP y la contraseña por correo.

Una vez hayamos creado el servidor, nos conectamos vía SSH a su dirección IP para administrarlo remotamente:

    $ ssh root@ip_del_servidor

Para descargar todo el software que necesitamos, tendremos que añadir algunos repositorios a nuestro sistema:

	#Repositorio pydio
	deb http://dl.ajaxplorer.info/repos/apt stable main
	deb-src http://dl.ajaxplorer.info/repos/apt stable main
	wget -O - http://dl.ajaxplorer.info/repos/charles@ajaxplorer.info.gpg.key | sudo apt-key add -

	#Repositorio webmin
	wget -t 5 http://www.webmin.com/jcameron-key.asc
	apt-key add jcameron-key.asc
	echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list 


## Cliente torrent

La herramienta básica de nuestro sistema es un cliente torrent. Hay varias alternativas posibles:

 - rTorrent
 - Deluge
 - uTorrent
 - qBitTorrent
 - ...

La instalación y configuración de estas herramientas es muy parecida, pero se va a explicar como llevarlas a cabo con **Deluge**, un cliente con licencia libre que incorpora interfaz de control vía web y un sistema de plugins que nos permite ampliar su funcionalidad.

Vamos a instalarlo a partir de el código fuente descargado de la página oficial, pues en los repositorios hay versiones desactualizadas:

    wget -N --no-check-certificate http://download.deluge-torrent.org/source/deluge-$DELUGE_VERSION.tar.gz
    tar xvfz deluge-$DELUGE_VERSION.tar.gz
    rm deluge-$DELUGE_VERSION.tar.gz
    cd deluge-$DELUGE_VERSION
    
    python setup.py build
    python setup.py install
    ldconfig

Una vez instalado, debemos permitir el acceso desde máquinas remotas; para ello ejecutamos:

	deluge-console "config -s allow_remote True"
	deluge-console "config allow_remote"

Por último, iniciamos el demonio y el proceso que sirve la interfaz web y accedemos a esta desde el navegador (la contraseña por defecto es 'deluge' y el puerto el 51106):

	deluged
	deluge-web --fork

![interfaz web](http://i.imgur.com/iWNcfHV.png)

Una vez aquí, podemos añadir nuevos torrent para descargar, cambiar las preferencias del programa,... 
Ahora es el momento de probar si la diferencia de velocidad merece la pena. Vamos a comprobarlo descargando una imagen iso de Ubuntu (1.1GB) con aproximadamente 190 leechers compartiendo:

![enter image description here](http://i.imgur.com/zmUEatu.png)
![enter image description here](http://i.imgur.com/I2FRNej.png)

Como vemos en la imagen, se alcanzan velocidades de más de **30MB/s**, descargando más de un gigabyte en 50 segundos.

##Accediendo a los archivos
Para evitar que todo el tráfico lo consuma el torrent podríamos priorizar siempre el tráfico que vaya por el puerto 80. Sin embargo, dado que la máquina va a estar sirviendo la mayor parte del tiempo (A no ser que se le dé un uso muy intenso), podemos simplemente limitar la velocidad de subida en la configuración del cliente. De este modo, tu no tienes más limitación que la que te da tu línea y el torrent se sigue compartiendo a una velocidad aceptable:

![enter image description here](http://i.imgur.com/yNN8USq.png)
### Descargar archivos mediante la interfaz web Pydio

El acceso vía web lo vamos a realizar con **Pydio**, un gestor de archivos online open source que nos da acceso rápido a todos los archivos, nos permite reorganizarlos y previsualizar algunos formatos.

También se instala desde los repositorios:

	# apt-get install pydio

Para configurarlo, movemos el archivo de configuración por defecto a su carpeta correspondiente, activamos el sitio con a2ensite y activamos el módulo rewrite:

	cp /usr/share/doc/pydio/apache2.sample.conf /etc/apache2/sites-available/pydio.conf
	a2ensite pydio.conf
	a2enmod rewrite

Una vez instalado, hay que seguir un asistente para su configuración que aparece la primera vez que intentamos acceder al servicio. El script final nos crea una base de datos y un usuario de forma automática. Una vez finalizado el asistente, debemos ir a settings > workspaces > new workspace y configurarlo con la carpeta donde se descargan nuestros archivos, asi:
![enter image description here](http://imgur.com/mSDkJOv.jpg)

Ahora, todos los archivos que descarguemos estarán disponibles en este nuevo workspace.

## Administrar el servidor con Webmin

Para evitar que tengamos que acceder por SSH para configurar o consultar el estado actual del servidor, podemos instalar Webmin, que nos dará acceso también web para el mantenimiento del servidor y la consulta de estadísticas:

    wget -t 5 http://www.webmin.com/jcameron-key.asc ; apt-key add jcameron-key.asc
    echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list 
    apt-get update
    apt-get --yes install webmin

Para acceder a esta herramienta utilizaremos el puerto 10000 y a través del navegador podremos cambiar configuraciones, ejecutar comandos, consultar estadísticas, actualizar paquetes,...

![enter image description here](http://i.imgur.com/dkCgX9H.png)

## Automatizando la instalación

Una vez que ya sabemos que herramientas vamos a necesitar y como se configuran, lo juntamos todo en un script para que realice todo el proceso de forma automática.

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

	mkdir /var/Descargas
	chmod -R 777 /var/Descargas

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
	mysql_secure_installation
	echo 'CREATE DATABASE pydio;' | mysql -u root -p
	echo "CREATE USER pydio@localhost IDENTIFIED BY 'password';" | mysql -u root -p
	echo "GRANT ALL PRIVILEGES ON pydio . * TO pydio@localhost;" | mysql -u root -p


	# Inicio de los servicios:
	deluged
	deluge-web --fork
	service apache2 restart
	service webmin start

	deluge-console "config -s allow_remote True"
	deluge-console "config allow_remote"
	deluge-console "config --set download_location /var/Descargas"

	echo -e "\n\n\n\n\n\nAcceso Deluge web: http://$IP_SERVIDOR:8112 (pass: deluge)"
	echo "Pydio: http://$IP_SERVIDOR/pydio/index.php"
	echo "Webmin https://$IP_SERVIDOR:10000"

Una vez termina de instalarlo todo, el propio script nos informa de las URLs de cada uno de los servicios.

## Y para terminar...

Por último, para dar mayor usabilidad a nuestro SeedBox, podemos instalar  en nuestro navegador DelugeSiphon, una extensión que captura los enlaces tipo magnet:// y los añade directamente a la cola de descargas. 
Se instala desde aquí: 

	https://chrome.google.com/webstore/detail/delugesiphon/gabdloknkpdefdpkkibplcfnkngbidim

y para configurarlo solo necesita saber la IP:puerto de nuestro servidor y la contraseña de acceso:

![enter image description here](http://i.imgur.com/7K5EEoT.png)

A partir de aquí ya se le pueden añadir todos los extras que nos puedan ser útiles: servidor multimedia, acceso por ftp, sincronización con rsync,...
Cabe añadir que en este tutorial no se ha tenido apenas en cuenta la seguridad. Si se le va  a dar un uso continuo habría que revisar la configuración en este aspecto.
