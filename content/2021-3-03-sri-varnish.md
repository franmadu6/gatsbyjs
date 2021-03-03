---
date: 2021-03-03
title: "[SERVICIOS] - Ejercicio: Aumento de rendimiento de servidores web von Varnish"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - SRI
tags:
    - Servidores web
    - Rendimiento
    - Varnish
---

![PracticaImg](images/servicios/varnish.jpg "varnish logo")



## Tarea 1: Vamos a configurar una máquina con la configuración ganadora: nginx + fpm_php (socket unix). Para ello ejecuta la receta ansible que encontraras en este [repositorio](https://github.com/josedom24/ansible_nginx_fpm_php). Accede al wordpress y termina la configuración del sitio.




## Tarea 2: Vamos a hacer las pruebas de rendimiento desde la misma máquina, es decir vamos a ejecutar instrucciones similares a esta:

```shell
ab -t 10 -c 200 -k http:/127.0.0.1/wordpress/index.php
```
## Realiza algunas prueba de rendimiento con varios valores distintos para el nivel de concurrencia (50,100,250,500) y apunta el resultado de peticiones/segundo (parámetro Requests per second de ab). Puedes hacer varias pruebas y quedarte con la media. Reinicia el servidor nginx y el fpm-php entre cada prueba para que los resultados sean los más reales posibles.



## Tarea 3: Configura un proxy inverso - caché Varnish escuchando en el puerto 80 y que se comunica con el servidor web por el puerto 8080. Entrega y muestra una comprobación de que varnish está funcionando con la nueva configuración. Realiza pruebas de rendimiento (quedate con el resultado del parámetro Requests per second) y comprueba si hemos aumentado el rendimiento. Si hacemos varias peticiones a la misma URL, ¿cuantas peticiones llegan al servidor web? (comprueba el fichero access.log para averiguarlo).



