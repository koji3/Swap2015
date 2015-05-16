


# Practica 4

Los ejercicios se han realizado con 2 máquinas virtuales con Ubuntu Server en 192.168.56.102 (Ubuntu_server_1) y 192.168.56.103 (Ubuntu_server_2) que actúan como servidores finales y otra en 192.168.56.105 que hace de balanceador.
Se muestra un ejemplo de ejecución, y la media de 10 ejecuciones por cada combinación herramienta/servidor. Los datos de cada ejecución están en un PDF en el repositorio. Para facilitar la recogida de los datos, se han utilizado comandos parecidos al siguiente:

	for i in $(seq 1 10); do 
		ab -n 1000 -c 10 192.168.56.103/script.php | egrep '(Time taken for test|Failed request|Time per request|Requests per second)' ; 
	done

En vez de una web estática, los servidores finales ejecutan un script PHP, para que se note más la sobrecarga del benchmark.
Es importante remarcar que no se pueden comparar los datos devueltos por 2 herramientas distintas porque cada una realiza el test de una forma.

##Medir rendimientos con ApacheBenchmark
###Rendimiento de una única máquina servidora

Ejecutamos el benchmark sobre la IP de una de las máquinas finales:

    ab -n 1000 -c 10 192.168.56.10/script.php

	Benchmarking 192.168.56.10 (be patient)
    Completed 100 requests
    Completed 200 requests
    [...]
    Finished 1000 requests
    
    
    Server Software:        Apache/2.4.7
    Server Hostname:        192.168.56.10
    Server Port:            80
    
    Document Path:          /script.php
    Document Length:        18 bytes
    
    Concurrency Level:      10
    Time taken for tests:   2.551 seconds
    Complete requests:      1000
    Failed requests:        217
       (Connect: 0, Receive: 0, Length: 217, Exceptions: 0)
    Total transferred:      204744 bytes
    HTML transferred:       17744 bytes
    Requests per second:    392.05 [#/sec] (mean)
    Time per request:       25.507 [ms] (mean)
    Time per request:       2.551 [ms] (mean, across all concurrent requests)
    Transfer rate:          78.39 [Kbytes/sec] received
    
    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   0.2      0       3
    Processing:     3   25  15.0     19      81
    Waiting:        3   23  13.7     18      81
    Total:          3   25  15.0     20      83
    
    Percentage of the requests served within a certain time (ms)
      50%     20
      66%     30
      75%     36
      80%     39
      90%     47
      95%     55
      98%     62
      99%     69
     100%     83 (longest request)

###Rendimiento de una granja web con Nginx

En este caso hacemos las peticiones a la máquina balanceadora mientras ejecuta nginx

    ab -n 1000 -c 10 192.168.56.105/script.php

    Benchmarking 192.168.56.105 (be patient)
    Completed 100 requests
    Completed 200 requests
    [...]
    Finished 1000 requests
    
    
    Server Software:        nginx/1.4.6
    Server Hostname:        192.168.56.105
    Server Port:            80
    
    Document Path:          /script.php
    Document Length:        18 bytes
    
    Concurrency Level:      10
    Time taken for tests:   2.266 seconds
    Complete requests:      1000
    Failed requests:        95
       (Connect: 0, Receive: 0, Length: 95, Exceptions: 0)
    Total transferred:      203897 bytes
    HTML transferred:       17897 bytes
    Requests per second:    441.28 [#/sec] (mean)
    Time per request:       22.662 [ms] (mean)
    Time per request:       2.266 [ms] (mean, across all concurrent requests)
    Transfer rate:          87.87 [Kbytes/sec] received
    
    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   0.2      0       3
    Processing:     3   22  21.0     13     102
    Waiting:        3   22  21.0     13     101
    Total:          3   23  21.1     13     102
    
    Percentage of the requests served within a certain time (ms)
      50%     13
      66%     25
      75%     38
      80%     45
      90%     54
      95%     63
      98%     75
      99%     80
     100%    102 (longest request)


###Rendimiento de una granja web con HaProxy

    ab -n 1000 -c 10 192.168.56.105/script.php
      
    Benchmarking 192.168.56.105 (be patient)
    Completed 100 requests
    Completed 200 requests
    [...]
    Finished 1000 requests
    
    
    Server Software:        Apache/2.4.7
    Server Hostname:        192.168.56.105
    Server Port:            80
    
    Document Path:          /script.php
    Document Length:        18 bytes
    
    Concurrency Level:      10
    Time taken for tests:   2.279 seconds
    Complete requests:      1000
    Failed requests:        138
       (Connect: 0, Receive: 0, Length: 138, Exceptions: 0)
    Total transferred:      204838 bytes
    HTML transferred:       17838 bytes
    Requests per second:    438.84 [#/sec] (mean)
    Time per request:       22.788 [ms] (mean)
    Time per request:       2.279 [ms] (mean, across all concurrent requests)
    Transfer rate:          87.78 [Kbytes/sec] received
    
    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   0.3      0       4
    Processing:     3   23  17.4     17      79
    Waiting:        3   20  15.2     15      73
    Total:          3   23  17.4     17      79
    
    Percentage of the requests served within a certain time (ms)
      50%     17
      66%     27
      75%     34
      80%     40
      90%     50
      95%     56
      98%     65
      99%     70
     100%     79 (longest request)

### Comparativa resultados ApacheBenchmark

|              _           | 1 sola máquina | Granja NGINX | Granja HaProxy |
|-------------------------|----------------|--------------|----------------|
| Time Taken (s)          | 19,42          | 17,28        | 18,26          |
| Failed Requests (#)     | 181            | 119           | 108            |
| Requests per second (#) | 51,50         | 57,86      | 54,75         |
| Time per request (ms)   | 194,19         | 172,84       | 182,64         |

Basándonos en los datos recogidos por ab, podemos ver que tener una granja web balanceada mejora notablemente el rendimiento frente a una única máquina. Dentro de tener dos máquinas, los resultados del balanceador Nginx son mejores, pues resuelve más peticiones por segundo, aunque el número de peticiones perdidas es mayor.
##Medir rendimientos con siege
Para medir el rendimiento de nuestras máquinas con siege el proceso es muy parecido al de ApacheBenchmark con la excepción de que tiene otra sintaxis en los parámetros.

###Rendimiento de una única máquina servidora
Lanzamos siege contra uno de los servidores finales saltándonos el balanceador:

    siege -b -t 60S -v 192.168.56.103/script.php
    ...
	Lifting the server siege...      done.
	
	Transactions:		        2951 hits
	Availability:		      100.00 %
	Elapsed time:		       59.11 secs
	Data transferred:	        0.05 MB
	Response time:		        0.30 secs
	Transaction rate:	       49.92 trans/sec
	Throughput:		        0.00 MB/sec
	Concurrency:		       14.95
	Successful transactions:        2951
	Failed transactions:	           0
	Longest transaction:	        0.53
	Shortest transaction:	        0.03





###Rendimiento de una granja web con NGINX 

	Lifting the server siege...      done.
	
	Transactions:		         310 hits
	Availability:		      100.00 %
	Elapsed time:		       59.25 secs
	Data transferred:	        0.01 MB
	Response time:		        1.88 secs
	Transaction rate:	        5.23 trans/sec
	Throughput:		        0.00 MB/sec
	Concurrency:		        9.83
	Successful transactions:         310
	Failed transactions:	           0
	Longest transaction:	        2.04
	Shortest transaction:	        1.71


###Rendimiento de una granja web con HaProxy

    Lifting the server siege...      done.

	Transactions:		         308 hits
	Availability:		      100.00 %
	Elapsed time:		       59.10 secs
	Data transferred:	        0.01 MB
	Response time:		        1.88 secs
	Transaction rate:	        5.21 trans/sec
	Throughput:		        0.00 MB/sec
	Concurrency:		        9.83
	Successful transactions:         310
	Failed transactions:	           0
	Longest transaction:	        2.04
	Shortest transaction:	        1.71


### Comparativa resultados siege

|              _           | 1 sola máquina | Granja NGINX | Granja HaProxy |
|-------------------------|----------------|--------------|----------------|
| Transactions (#)         | 316          | 311        | 313          |
| Elapsed Time (s)     | 59,51            | 59,50           | 59,47            |
| Failed transactions (#) | 0         | 0      | 0         |
| Transaction rate (#/s)  | 5,32         | 5,22       | 5,27         |

En este caso, los resultados de las distintas configuraciones son demasiado parecidos como para señalar un ganador. Esto puede ser porque en realidad no se estaban ejecutando en máquinas distintas, sino que eran máquinas virtuales compartiendo los recursos del mismo anfitrión
