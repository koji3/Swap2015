#Tema 3

###Buscar con qué órdenes de terminal o herramientas gráficas podemos configurar bajo Windows y bajo Linux el enrutamiento del tráfico de un servidor para pasar el tráfico desde una subred a otra.

Desde Linux utilizamos el comando route:

	# route add -net 119.235.0.0/16 gw 192.168.1.1 dev eth0

Esto redirigiría el tráfico destinado a la red *119.235.0.0/16* a través de la interfaz *eth0*, utilizando *192.168.1.1* como gateway. Para eliminar esta ruta, en vez de *add* utilizamos *del*:

	# route del -net 119.235.0.0/16 eth0
Para hacer la misma operación en windows (la opción -p para que se mantenga al reiniciar):
 
	route -p ADD 119.235.0.0/16 192.168.1.1

Y para borrar...
	
	route delete 119.235.0.0/16

### Buscar con qué órdenes de terminal o herramientas gráficas podemos configurar bajo Windows y bajo Linux el filtrado y bloqueo de paquetes.

El filtrado de paquetes en Linux se hace principalmente con iptables. Las opciones que tiene son muchas, pero por poner algunos ejemplos de uso:
	
	// Aceptar todas las entradas y salidas
	iptables --policy INPUT ACCEPT
	iptables --policy OUTPUT ACCEPT
	
	//Denegar todas las entradas y salidas de un rango
	iptables --policy -s 10.10.10.0/24 -j DROP

	//Denegar las conexiones ssh
	iptables -A INPUT -p tcp --dport ssh -j DROP
	
En windows las opciones son más variadas. Entre ellas están SmartSniff, PKTFILTER y el propio bloqueador del sistema.





### Referencias:

 - http://rm-rf.es/enrutar-en-linux-route-add-del/
 - https://technet.microsoft.com/en-us/library/cc739598%28v=ws.10%29.aspx
 - http://www.netfilter.org/documentation/HOWTO/packet-filtering-HOWTO-3.html
 - http://www.howtogeek.com/177621/the-beginners-guide-to-iptables-the-linux-firewall/
 - https://technet.microsoft.com/en-us/library/cc732746%28v=ws.10%29.aspx
