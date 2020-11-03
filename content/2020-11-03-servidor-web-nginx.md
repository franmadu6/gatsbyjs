---
date: 2020-11-03
title: "Servidor web nginx"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - Servicios
tags:
    - nginx
---

## Tarea 1 (1 punto)(Obligatorio): Crea una máquina del cloud con una red pública. Añade la clave pública del profesor a la máquina. Instala el servidor web nginx en la máquina. Modifica la página index.html que viene por defecto y accede a ella desde un navegador.

### Entrega la ip flotante de la máquina para que el profesor pueda acceder a ella.
### Entrega una captura de pantalla accediendo a ella

Primero instalaremos el servidor Gninx en nuestra maquina.
'''shell
debian@servidor-gninx:~$ sudo apt-get install nginx
'''
El sistema de directorios de nginx es muy similar al de apache, tendremos que configurar nuevo archivo de configuración en sites-avaliable para especificar nuestro sitio.
'''shel

'''