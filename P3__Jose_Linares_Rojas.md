# Practica 3

Los ejercicios se han realizado con 2 máquinas virtuales con Ubuntu Server en 192.168.56.103 (Ubuntu_server_1) y 192.168.56.102 (Ubuntu_server_2) que actúan como servidores finales y otra en 10.0.2.15 que hace de balanceador.

## 1 Configurar una máquina e instalarle nginx como balanceador de carga

A partir de una instalación limpia de Ubuntu Server en una tercera máquina virtual, pasamos a instalar en esta máquina nginx, que será el software que se encargará de balancear la carga a los distintos servidores finales:

    Ubuntu_server_balanceador# apt-get install nginx

Para adecuar el funcionamiento de esta herramienta al uso que le queremos dar, modificamos (o creamos) el archivo */etc/nginx/nginx.conf*, dejándolo así:

/p3_configuracion_nginx.png

Para comprobar que funciona, accedemos a la IP del servidor y vemos como carga alternativamente desde el servidor 1 y luego desde el 2:

Si añadimos el parámetro *weight* en la configuración a los servidores finales, podemos establecer el peso que tendrá cada uno a la hora de redirigirles el tráfico. Por ejemplo, si establecemos los pesos de esta manera:

    upstream apaches {
	    server 192.168.56.102 weight=1;
	    server 192.168.56.103 weight=2;
    }

La carga se repartiría así:

## 1 Configurar una máquina e instalarle haproxy como balanceador de carga