---
date: 2021-04-06
title: "[IAW] - Práctica: Implantación de aplicaciones web PHP en docker "
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - IAW
tags:
    - PHP
    - Docker
---

## Práctica: Implantación de aplicaciones web PHP en docker.

<hr>

### Tarea 1: Ejecución de una aplicación web PHP en docker.


* Queremos ejecutar en un contenedor docker la aplicación web escrita en PHP: bookMedik (https://github.com/evilnapsis/bookmedik).

* Es necesario tener un contenedor con mariadb donde vamos a crear la base de datos y los datos de la aplicación. El script para generar la base de datos y los registros lo encuentras en el repositorio y se llama schema.sql. Debes crear un usuario con su contraseña en la base de datos. La base de datos se llama bookmedik y se crea al ejecutar el script.

* Ejecuta el contenedor mariadb y carga los datos del script schema.sql. Para más información.

* El contenedor mariadb debe tener un volumen para guardar la base de datos.

* El contenedor que creas debe tener un volumen para guardar los logs de apache2.

* Crea una imagen docker con la aplicación desde una imagen base de debian o ubuntu. Ten en cuenta que el fichero de configuración de la base de datos (core\controller\Database.php) lo tienes que configurar utilizando las variables de entorno del contenedor mariadb. (Nota: Para obtener las variables de entorno en PHP usar la función getenv. Para más infomación).

* La imagen la tienes que crear en tu máquina con el comando docker build.

* Crea un script con docker compose que levante el escenario con los dos contenedores.(Usuario: admin, contraseña: admin).

<hr>

El primer paso será clonar el repo de la aplicación.
```shell
root@debian:/home/fran/Docker# git clone https://github.com/evilnapsis/bookmedik.git
Clonando en 'bookmedik'...
remote: Enumerating objects: 856, done.
remote: Total 856 (delta 0), reused 0 (delta 0), pack-reused 856
Recibiendo objetos: 100% (856/856), 1.90 MiB | 2.14 MiB/s, listo.
Resolviendo deltas: 100% (372/372), listo.
```

Crearemos un repositorio en GitHub con la siguiente estructura, donde bookmedik es el repositorio que acabamos de clonar.
```shell
├── build
│   ├── bookmedik
│   ├── Dockerfile
│   └── script.sh
├── deploy
│   └── docker-compose.yml
└── README.md
```

Instalaremos docker-compose.
```shell
fran@debian:~/GitHub/PHP-en-Docker/deploy$ sudo apt-get install docker-compose
```

Crearemos el documento de **docker-compose.yml**.
```shell
version: '3.1'

db:
     container_name: servidor_mysql
     image: mariadb
     restart: always
     environment:
           MYSQL_DATABASE: bookmedik
           MYSQL_USER: user_bookmedik
           MYSQL_PASSWORD: pass_bookmedik
           MYSQL_ROOT_PASSWORD: asdasd
     volumes:
           - /opt/mysql:/var/lib/mysql
```

Lo ejecutaremos:
```shell

```

```shell

```

```shell

```

```shell

```
