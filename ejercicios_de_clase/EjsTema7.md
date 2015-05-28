# Tema 7

### ¿Qué tamaño de unidad de unidad RAID se obtendrá al configurar un RAID 0 a partir de dos discos de 100 GB y 100 GB?
200GB
### ¿Qué tamaño de unidad de unidad RAID se obtendrá al configurar un RAID 0 a partir de tres discos de 200 GB cada uno?
600GB
### ¿Qué tamaño de unidad de unidad RAID se obtendrá al configurar un RAID 1 a partir de dos discos de 100 GB y 100 GB?
100GB
### ¿Qué tamaño de unidad de unidad RAID se obtendrá al configurar un RAID 1 a partir de tres discos de 200 GB cada uno?
200GB
### ¿Qué tamaño de unidad de unidad RAID se obtendrá al configurar un RAID 5 a partir de tres discos de 120 GB cada uno?
casi 240GB
### Buscar información sobre los sistemas de ficheros en red más utilizados en la actualidad y comparar sus características. Hacer una lista de ventajas e inconvenientes de todos ellos, así como grandes sistemas en los que se utilicen.

 - NFS: Todos los ficheros estan almacenados en un servidor central, al que acceden los clientes. Utiliza comunicación síncrona, es decir, el servidor no responde hasta que los datos están escritos en disco, asegurando así la integridad de los datos.
 
 - AFS: Aporta beneficios en aspectos de seguridad y escalabilidad. Utiliza kerberos como método de autentificación, e implementa listas de control de acceso. Cada cliente almacena una caché en el sistema de archivos local para mejorar la velocidad del sistema.
