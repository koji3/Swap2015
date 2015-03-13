# Practica 2

Los ejercicios se han realizado con 2 máquinas virtuales con Ubuntu Server en 192.168.56.103 (Ubuntu_server_1) y 192.168.56.102 (Ubuntu_server_2).

## 1 Clonar archivos con ssh

Para clonar archivos por SSH existen varios métodos; uno de ellos es el que aparece en el guión, redirigiendo el contenido del archivo a ssh para que lo envíe a la máquina destino y, una vez allí, lo guarde en disco:

	Ubuntu_server_2:  cat archivo | ssh joselito@192.168.56.103 'cat > ~/archivo'
	joselito@192.168.56.103`s password: 


	Ubuntu_server_1:  ls	#Antes de la copia
	test.tgz
	Ubuntu_server_1:  ls	#Despues de la copia
	archivo  test.tgz
	Ubuntu_server_1:  cat archivo 
	Hola Hola 

Otra forma más simple de hacerlo es con scp, que lo que hace básicamente es automatizar el proceso anterior:

	Ubuntu_server_2:  scp archivo2 joselito@192.168.56.103:~/archivo2
	joselito@192.168.56.103`s password: 
	archivo2                                           100%    6     0.0KB/s   00:00 
	

	Ubuntu_server_1:  ls
	archivo  archivo2  test.tgz

## 2 Clonado de una carpeta entre las dos máquinas

Haciendo uso de rsync, para clonar una carpeta basta con ejecutar:

	Ubuntu_server_2:  rsync -avz --delete -e ssh root@192.168.56.103:/var/www/ /var/www/
	root@192.168.56.103`s password: 
	receiving incremental file list
	
	sent 21 bytes  received 94 bytes  32.86 bytes/sec
	total size is 11,510  speedup is 100.09

	
Es importante el acceso con root para asegurarnos de que no hay problema con los permisos, aunque no modificará los permisos en absoluto. Para que ssh nos permita el acceso root hay que modificar el parámetro *PermitRootLogin* en el archivo */etc/ssh/sshd_config*


## 3 Configuración de ssh para acceder sin contraseña 

Primero generamos un par de claves pública/privada y luego copiamos nuestra clave pública en la otra máquina:

	Ubuntu_server_2:  ssh-keygen -b 4096 -t rsa
	Generating public/private rsa key pair.
	Enter file in which to save the key (/home/joselito/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /home/joselito/.ssh/id_rsa.
	Your public key has been saved in /home/joselito/.ssh/id_rsa.pub.
	The key fingerprint is:
	e1:50:bf:29:a6:b6:11:d1:c8:04:b3:36:ca:07 joselito@ubuntu1
	The key`s randomart image is:
	+--[ RSA 4096]----+
	|    o.. .      . |
	|     o + .    .  |
	|    . = o .      |
	|     . + . o     |
	|    ..    o      |
	|   .E. + .       |
	|    o()          |
	|   . o+o     0.  |
	|    o+o.       . |
	+-----------------+
	Ubuntu_server_2:  ssh-copy-id root@192.168.56.103
	/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
	/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
	root@192.168.56.103's password: 
	
	Number of key(s) added: 1
	
Luego intentamos acceder y comprobamos que, efectivamente, no nos pide la contraseña:

	Ubuntu_server_2:  ssh root@192.168.56.103
	root@Ubuntu1:



## 4 Establecer una tarea en cron que se ejecute cada hora para mantener actualizado el contenido del directorio /var/www entre las dos máquinas

Para establecer una nueva tarea programada, añadimos la siguiente línea al archivo de crontab

	0 * * * * rsync -avz --delete -e ssh root@192.168.56.103:/var/www/ /var/www/
