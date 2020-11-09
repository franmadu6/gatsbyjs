---
date: 2020-11-03
title: "Servidor web nginx"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - Servicios
tags:
    - Nginx
---

## Tarea 1 (1 punto)(Obligatorio): Crea una máquina del cloud con una red pública. Añade la clave pública del profesor a la máquina. Instala el servidor web nginx en la máquina. Modifica la página index.html que viene por defecto y accede a ella desde un navegador.

### Entrega la ip flotante de la máquina para que el profesor pueda acceder a ella.
Ip flotante de la maquina es ->  *172.22.200.137*

### Entrega una captura de pantalla accediendo a ella
![PracticaImg](images/servicios/nginx-1.png "Imagen de la practica")

#### Virtual Hosting
Primero instalaremos el servidor Gninx en nuestra maquina.
```shell
debian@servidor-gninx:~$ sudo apt-get install nginx
```

Copiaremos el archivo default para crear la base de nuestros dos sitios web.
```shell
debian@servidor-gninx:/etc/nginx/sites-available$ sudo cp default iesgn
debian@servidor-gninx:/etc/nginx/sites-available$ sudo cp default departamentos
debian@servidor-gninx:/etc/nginx/sites-available$ ls
default  departamentos  iesgn
```

**Ficheros de configuración**
iesgn:
```shell

```


departamentos:
```shell

```

hosts:
```shell

```

## Tarea 2 (2 punto)(Obligatorio): Configura la resolución estática en los clientes y muestra el acceso a cada una de las páginas.

El sistema de directorios de nginx es muy similar al de apache, tendremos que configurar nuevo archivo de configuración en sites-avaliable para especificar nuestro sitio.
```shell

```