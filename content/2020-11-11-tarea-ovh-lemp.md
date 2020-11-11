---
date: 2020-11-11
title: "Tarea OVH. Lemp"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - Servicios
tags:
    - OVH
    - Lemp
---

## Instalación de un servidor LEMP (Servicios)

1. Instala un servidor web nginx
2. Instala un servidor de base de datos MariaDB. Ejecuta el programa necesario para asegurar el servicio, ya que lo vamos a tener corriendo en el entorno de producción.
3. Instala un servidor de aplicaciones php php-fpm.
4. Crea un virtualhost al que vamos acceder con el nombre www.iesgnXX.es. Recuerda que tendrás que crear un registro CNAME en la zona DNS.
5. Cuando se acceda al virtualhost por defecto default nos tiene que redirigir al virtualhost que hemos creado en el punto anterior.
6. Cuando se acceda a www.iesgnXX.es se nos redigirá a la página www.iesgnXX.es/principal
7. En la página www.iesgnXX.es/principal se debe mostrar una página web estática (utiliza alguna plantilla para que tenga hoja de estilo). En esta página debe aparecer tu nombre, y una lista de enlaces a las aplicaciones que vamos a ir desplegando posteriormente.
8. Configura el nuevo virtualhost, para que pueda ejecutar PHP. Determina que configuración tiene por defecto php-fpm (socket unix o socket TCP) para configurar nginx de forma adecuada.
9. Crea un fichero info.php que demuestre que está funcionando el servidor LEMP.

Documenta de la forma más precisa posible cada uno de los pasos que has dado, y entrega pruebas de funcionamiento para comprobar el proceso que has realizado.