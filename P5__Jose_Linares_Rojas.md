# Práctica 5: Replicación de bases de datos MySQL

Los ejercicios se han realizado con 2 máquinas virtuales con Ubuntu Server en 192.168.56.102 (Que hará de maestro) y 192.168.56.103 (Que hará de esclavo).

## Rellenar la base de datos

Para comprobar que los datos se copian bien entre máquinas es importante que primero tengamos algunos datos que copiar. Para crear una nueva base de datos MySQL e introducirle algunos datos ejecutamos:

	mysql -u root -p
	Enter password: ********
	[...]
	mysql> create database prueba;
	mysql> use prueba;
	mysql> create table datos(nombre varchar(50), edad int);
	mysql> insert into datos values("juan", 34);
	mysql> insert into datos values("maria", 26);

## Backup manual

Ahora que tenemos datos para copiar, vamos a hacer un volcado de la base de datos entera con mysqldump para luego cargarlo en la máquina esclava. Para esto, lo primero que hay que hacer es bloquear las tablas de la máquina maestra. Luego volcamos el contenido en un archivo y volvemos a desbloquear las tablas. Por último copiamos el dump al esclavo y se lo pasamos a mysql para que lo interpete.
Todo esto en un script quedaría así:

	#!/bin/bash
	echo "FLUSH TABLES WITH READ LOCK;" | mysql -u root -p"pass"
	mysqldump prueba -u root -p"pass" | ssh 192.168.56.103 mysql -u root -p"pass"
	echo "UNLOCK TABLES;" | mysql -u root -p"pass"

Antes de ejecutar el script tiene que estar creada la base de datos en el esclavo también. Para comprobar que efectivamente funciona, solo tenemos que introducir datos en el maestro y ejecutar el script:
![enter image description here](http://i.imgur.com/h5wAteu.png?1)

![enter image description here](http://i.imgur.com/44WVJPA.png?1)

Aunque este proceso es relativamente rápido, podemos agilizar aún mas la copia de datos utilizando las herramientas que ofrece mysql para la replicación de tablas.

## Backup Automático

Lo primero que hay que hacer es configurar el maestro editando el archivo */etc/mysql/my.cnf* y modificando los siguientes campos:

	#bind-address 127.0.0.1 
	log_error = /var/log/mysql/error.log
	server-id = 1
	log_bin = /var/log/mysql/mysql-bin.log

Una vez guardado reiniciamos el servicio:

	/etc/init.d/mysql restart

Ahora pasamos a configurar el esclavo, en este mismo archivo de configuración, y con los mismos parámetros, salvo el server-id que pasará a ser 2.
Ahora creamos un usuario en el maestro con permisos para copiar la base de datos:

![enter image description here](http://i.imgur.com/92pZOs9.png)

La última sentencia sirve para ver algunos parámetros de configuración que luego tendremos que pasarle al esclavo. Para hacerlo, abrimos el interprete mysql en el esclavo y ejecutamos:
	
	CHANGE MASTER TO MASTER_HOST='192.168.56.102', MASTER_USER='esclavo', MASTER_PASSWORD='esclavo', MASTER_LOG_FILE='mysql-bin.000002', MASTER_LOG_POS=501, MASTER_PORT=3306;

Reiniciamos mysql e iniciamos el esclavo. A partir de ahora cualquier modificación en el maestro se volcará automáticamente en el esclavo.
