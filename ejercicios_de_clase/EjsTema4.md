# Tema 4

### Buscar información sobre cuánto costaría en la actualidad un mainframe. Comparar precio y potencia entre esa máquina y una granja web de unas prestaciones similares.

Los costes de un mainframe pueden llegar a los cientos de dólares, cuando una granja web de ese precio tendría un rendimiento muy superior al estar formada por muchos nodos de cómputo independientes. El precio exacto de estos servidores no está publicado.

### Probar las diferentes maneras de redirección HTTP. ¿Cuál es adecuada y cuál no lo es para hacer balanceo de carga global? ¿Por qué?
Es mejor indicar la redirección en la cabecera del archivo, para que el navegador cargue la dirección correcta sin tener que interpretar el contenido del paquete, cosa que tendría que hacer si la redirección se indicase en el html, o si se hiciese con javascript. 

### Buscar información sobre los bloques de IP para los distintos países o continentes. Implementar en JavaScript o PHP la detección de la zona desde donde se conecta un usuario.

Para detectar la zona del usuario que se conecta basta con hacer uso de servicios como , parametrizándolo con la dirección IP del cliente:

	<?php
	$ip=$_SERVER['REMOTE_ADDR'];
	$datos = file_get_contents("http://freegeoip.net/xml/$ip");

	preg_match('|(<CountryName>)(.*?)(</CountryName>)|' , $datos , $res );

	echo "Pais: ".$res[2]."<br>";
	echo "IP:".$ip;
	?>
	



