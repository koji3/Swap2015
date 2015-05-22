# Tema 2
###Ejercicio T2.1

**Calcular la disponibilidad del sistema descrito en edgeblog.net si tenemos dos réplicas de cada elemento salvo para el centro de datos (en total 3 elementos en cada subsistema).**

Si tuviésemos 3 elementos en cada subsistema, la disponibilidad del sistema completo sería 0,99213%.

### Ejercicio T2.2
**Buscar frameworks y librerías para diferentes lenguajes que permitan hacer aplicaciones altamente disponibles con relativa facilidad. Como ejemplo, examina PM2: https://github.com/Unitech/pm2 que sirve para administrar clústeres de NodeJS.**

- spring (spring.io)
- supervizer (https://github.com/oOthkOo/supervizer)
- forever (https://github.com/foreverjs/forever)

### Ejercicio T2.3
**¿Cómo analizar el nivel de carga de cada uno de los subsistemas en el servidor? Buscar herramientas y aprender a usarlas.**

- Memoria
	- free
	- top
	- vmstat
- Disco
	- vmstat
	- iotop
	- iostat
- CPU
	- top
	- htop
- Red
	- tcpdump
	- netstat
	- nethogs

### Ejercicio T2.4
**En este ejercicio debemos buscar diferentes tipos de productos: 
(1) Buscar ejemplos de balanceadores software y hardware.
(2) Buscar productos comerciales para servidores de aplicaciones.
(3) Buscar productos comerciales para servidores de almacenamiento.**

- Balanceadores
	- software
		- Zen Load Balancer (http://www.zenloadbalancer.com/)
		- HAProxy (http://www.haproxy.org/)
		- BalanceNG (http://www.inlab.de/balanceng/)
	- hardware
		- F5 (https://f5.com/)
		- Citrix (http://www.citrix.com)
		- Cisco (http://www.cisco.com/)
- Servidores de aplicaciones
	- WebLogic
	- JBoss
	- WebSphere
	- TomEE
- Servidores de almacenamiento
	- FreeNAS

####Referencias

- http://www.tecmint.com/command-line-tools-to-monitor-linux-performance/
