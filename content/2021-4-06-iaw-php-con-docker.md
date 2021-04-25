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
version: "3.1"

services:
  db:
    container_name: servidor_mysql
    image: mariadb
    restart: always
    environment:
      MYSQL_DATABASE: bookmedik
      MYSQL_USER: bookmedik
      MYSQL_PASSWORD: bookmedik
      MYSQL_ROOT_PASSWORD: fran
    volumes:
      - /opt/mysql_wp:/var/lib/mysql
```

Lo ejecutaremos:
```shell
root@debian:/home/fran/GitHub/PHP-en-Docker/deploy# docker-compose up -d
Creating network "deploy_default" with the default driver
Creating servidor_mysql ... done
```

En el directorio **Build** deberemos crear el fichero **Dockerfile** en el que indicaremos como se genera nuestra imagen y tambien clone el repositorio de bookmedik:
```shell
FROM debian

RUN apt-get update && apt-get install -y apache2 libapache2-mod-php7.3 php7.3 php7.3-mysql && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN rm /var/www/html/index.html

ENV APACHE_SERVER_NAME=www.bookmedik-madu.org
ENV DATABASE_USER=bookmedik
ENV DATABASE_PASSWORD=bookmedik
ENV DATABASE_HOST=bd

EXPOSE 80

COPY ./bookmedik /var/www/html
ADD script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

CMD ["/usr/local/bin/script.sh"]
```

En el mismo directorio **Build** crearemos un fichero llamado **script.sh** en el cual indicaremo las variables de entorno necesarias.
```shell
sed -i 's/$this->user="root";/$this->user="'${DATABASE_USER}'";/g' /var/www/html/core/controller/Database.php
sed -i 's/$this->pass="";/$this->pass="'${DATABASE_PASSWORD}'";/g' /var/www/html/core/controller/Database.php
sed -i 's/$this->host="localhost";/$this->host="'${DATABASE_HOST}'";/g' /var/www/html/core/controller/Database.php
apache2ctl -D FOREGROUND
```

Una vez echo esto debemos generar nuestra nueva imagen a partir del fichero **Dockerfile** en **Build** ejecutaremos el siguiente comando:
```shell
root@debian:/home/fran/GitHub/PHP-en-Docker/build# docker build -t fran/bookmedik:v1 .
#comprobación
root@debian:/home/fran/GitHub/PHP-en-Docker/build# docker image list
REPOSITORY                    TAG                 IMAGE ID            CREATED             SIZE
fran/bookmedik                v1                  3f5a2e37e3b6        3 seconds ago       251MB
```

Despligue de docker-compose, ya con la imagen creada, editaremos nuevamente el fichero **docker-compose.yml** para añadir el nuevo contenedor donde estará alojada nuestra aplicación de bookmedik:
```shell
version: "3.1"

services:
  db:
    container_name: servidor_mysql
    image: mariadb
    restart: always
    environment:
      MYSQL_DATABASE: bookmedik
      MYSQL_USER: bookmedik
      MYSQL_PASSWORD: bookmedik
      MYSQL_ROOT_PASSWORD: fran
    volumes:
      - /opt/mysql_bookmedik:/var/lib/mysql

  bookmedik:
    container_name: bookmedik
    image: fran/bookmedik:v1
    restart: always
    ports:
      - 8082:80
    volumes:
      - /opt/bookmedik:/var/log/apache2
```

Ejecutamos nuevamente:
```shell
root@debian:/home/fran/GitHub/PHP-en-Docker/deploy# docker-compose up -d
Recreating servidor_mysql ... done
Creating bookmedik        ... done
```

```shell

```


### Tarea 2: Ejecución de una aplicación web PHP en docker.


* Realiza la imagen docker de la aplicación a partir de la imagen oficial PHP que encuentras en docker hub. Lee la documentación de la imagen para configurar una imagen con apache2 y php, además seguramente tengas que instalar alguna extensión de php.
* Crea esta imagen en docker hub.
* Crea un script con docker compose que levante el escenario con los dos contenedores.

<hr>


### Tarea 3: Ejecución de una aplicación PHP en docker.


* En este caso queremos usar un contenedor que utilice nginx para servir la aplicación PHP. Puedes crear la imagen desde una imagen base debian o ubuntu o desde la imagen oficial de nginx.
* Vamos a crear otro contenedor que sirva php-fpm.
* Y finalmente nuestro contenedor con la aplicación.
* Crea un script con docker compose que levante el escenario con los tres contenedores.

A lo mejor te puede ayudar el siguiente enlace: Dockerise your PHP application with Nginx and PHP7-FPM

<hr>

### Tarea 4: Ejecución de un CMS en docker.


* A partir de una imagen base (que no sea una imagen con el CMS), genera una imagen que despliegue un CMS PHP (que no sea wordpress).

* Crea los volúmenes necesarios para que la información que se guarda sea persistente.

<hr>

### Tarea 5: Ejecución de un CMS en docker.

Busca una imagen oficial de un CMS PHP en docker hub (distinto al que has instalado en la tarea anterior, ni wordpress), y crea los contenedores necesarios para servir el CMS, siguiendo la documentación de docker hub.

<hr>
