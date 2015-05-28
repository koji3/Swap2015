# Tema 6

### Aplicar con iptables una política de denegar todo el tráfico en una de las máquinas de prácticas. Comprobar el funcionamiento. Aplicar con iptables una política de permitir todo el tráfico en una de las máquinas de prácticas. Comprobar el funcionamiento.
![iptables](http://i.imgur.com/StLKWIS.png)
### Comprobar qué puertos tienen abiertos nuestras máquinas, su estado, y qué programa o demonio lo ocupa.
Para comprobar que puertos hay abiertos usamos el comando:

	netstat -punlt 
	
![netstat](http://i.imgur.com/i59GAN7.png)
### Buscar información acerca de los tipos de ataques más comunes en servidores web, en qué consisten, y cómo se pueden evitar.
Los ataques que más suelen realizarse sobre páginas web son los de inyección SQL, que consisten en introducir comandos válidos de SQL en los campos de entrada de datos del usuario. Estos comandos están fabricados con el propósito de entrar en la base de datos. Para evitarlos basta con validar todos los campos de las webs que tenga el servidor.
Otro tipo de ataque importante es el DOS, que consiste en sobrecargar el servidor aplicando sobre el mas tráfico del que puede soportar (normalmente proveniente de botnets que hacen muchas peticiones pesadas simultáneas ). Para evitar estos ataques es bueno que el sistema esté balanceado para que no reciba todo el ataque una sola máquina, asi como un sistema que detecte y neutralice estos ataques.
