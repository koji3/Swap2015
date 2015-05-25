# Practica 6: Discos en RAID

## Instalar y configurar dos discos en RAID 1
Para configurar un RAID, lo primero que se necesita es el programa mdadm:

	# apt-get install mdadm

Luego identificamos los 2 discos que utilizaremos para el RAID:

	# fdisk -l

![enter image description here](http://i.imgur.com/9IxJKJL.png)

Se recomienda que ambos discos sean iguales, pues el tamaño máximo del RAID será igual al mas pequeño de los dos. En mi caso será /dev/sdb y /dev/sdc.

Ahora pasamos a hacer el RAID1 y a darle formato:
	
	# mdadm -C /dev/md0 --level=raid1 --raid-devices=2 /dev/sdb /dev/sdc
	# mkfs /dev/md0

Para montar el nuevo dispositivo, creamos una carpeta nueva y ejecutamos mount:

	# mkdir /datos
	# mount /dev/md0 /datos

Llegados a este punto, ya podemos utilizar el nuevo RAID desde nuestro sistema de archivos:

![enter image description here](http://i.imgur.com/7FSjDdm.png)

Ahora necesitamos el UUID del dispositivo. Lo conseguimos ejecutando:

	blkid /dev/md0

Por último, añadimos una línea al archivo */etc/fstab* para que el sistema monte este dispositivo al arrancar.:

	# echo "UUID=asdfghj-asdfghjk-asdfghjk-asdfghjkls /datos ext2 defaults 0 0" >> /etc/fstab
													
Para comprobar que funciona vamos a eliminar uno de los discos y a comprobar que el dispositivo virtual del RAID sigue funcionando:

![enter image description here](http://i.imgur.com/Bl8ixn5.png)
(El disco /dev/sdc está desconectado pero el directorio /datos sigue funcionando)


