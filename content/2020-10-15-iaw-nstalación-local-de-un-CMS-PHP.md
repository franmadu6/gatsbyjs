---
date: 2020-10-15
title: "[IAW] - P1. Instalación local de un CMS PHP"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - IAW
tags:
    - CMS
    - PHP
    - LAMP
    - Drupal
---

# Tarea 1: Instalación de un servidor LAMP

1. **Crea una instancia de vagrant basado en un box debian o ubuntu.**
```shell
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "debian/buster64"
  config.vm.hostname = "drupal"
  config.vm.network "private_network", ip: "192.168.100.5"

end
```

2. **Instala en esa máquina virtual toda la pila LAMP**

```shell
#Instalamos apache2 y apache2-utils
sudo apt-get install -y apache2 apache2-utils
#Instalamos el servidor y el cliente de mariadb
sudo apt-get install -y mariadb-server mariadb-client
#los dos pasos anteriores puede que ya vengan instalados por defecto
#Instalamos php y los módulos necesarios y recomendables de php
sudo apt-get install php libapache2-mod-php php-cli php-fpm php-json php-pdo php-mysql php-zip php-gd  php-mbstring php-curl php-xml php-pear php-bcmath
```


# Tarea 2: Instalación de drupal en mi servidor local

1. **Configura el servidor web con virtual hosting para que el CMS sea accesible desde la dirección: www.nombrealumno-drupal.org.**

```shell
ServerName www.madu-drupal.org
```

2. **Crea un usuario en la base de datos para trabajar con la base de datos donde se van a guardar los datos del CMS.**

```shell
vagrant@drupal:~$ sudo mysql -u root -p

MariaDB [(none)]> create user 'fmadu' identified by 'dios';
Query OK, 0 rows affected (0.005 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'fmadu'@'localhost'
    -> IDENTIFIED BY 'dios' WITH GRANT OPTION;
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> exit
Bye
vagrant@drupal:~$ mysql -u fmadu -p

MariaDB [(none)]> create database fmadudb;
Query OK, 1 row affected (0.002 sec)
```

3. **Descarga la versión que te parezca más oportuna de Drupal y realiza la instalación.**

Descargamos drupal de la web oficial,(la ultima version).
```shell
vagrant@drupal:/etc/apache2/sites-available$ sudo wget https://www.drupal.org/download-latest/zip
```

Creamos el directorio drupal en /var/www/, descomprimimos el fichero descargado y copiamos su contenido en dicho directorio.
```shell
sudo mkdir /var/www/drupal
sudo apt install unzip
sudo unzip zip
sudo mv drupal-9.0.7/* /var/www/drupal
```
En /var/www/ y le damos los respectivos permisos necesarios.
```shell
chown www-data drupal/
chgrp www-data drupal/
```

Añadimos la nueva ruta a nuestro archivo de configuracion.
```shell
DocumentRoot /var/www/drupal
```

Enlace simbolico:
```shell
vagrant@drupal:/etc/apache2/sites-available$ sudo a2ensite drupal
```

Cambiamos el usuario del directorio.
```shell
vagrant@drupal:/etc/apache2/sites-available$ sudo chown -R www-data:www-data /var/www/drupal/
```

Recargamos apache2:
```shell
systemctl reload apache2
```

Modificamos el fichero  hosts en nuestra maquina fisica.
```shell
192.168.100.5       www.madu-drupal.org
```

El contenido de este archivo es un bloque Directory para el directorio de Drupal en el que una directiva AllowOverride permitirá el uso de los archivos **.htaccess**:
```shell
        <Directory /var/www/drupal>
                AllowOverride all
        </Directory>
```

Con estos pasos hechos correctamente podremos ver como podemos usar drupal desde nuestro navegador
![PracticaImg](images/iaw/drupalfound.png "drupal1")

Una vez realizado todos los procedimientos de configuración del asistente de instalación, tendremos instalado drupal en nuestro servidor.
El proceso es muy simple típico siguiente,siguiente,siguiente...

Me salia un error de no tener URL limpia configurada lo he solucionado, activando el mod_rewrite y modificando el fichero apache.conf en la siguiente linea
```shell
#Para tener una URL limpia, añadimos el siguiente módulo y cambiamos el AllowOverride de "None" a "All":
vagrant@drupal:/var/www/html$ sudo a2enmod rewrite
vagrant@drupal:/etc/apache2$ sudo nano apache2.conf
<Directory /var/www/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>
```

4. **Realiza una configuración mínima de la aplicación (Cambia la plantilla, crea algún contenido, …)**

Dentro de nuestra web de drupal accederemos a apariencias -> nueva plantilla -> ponemos la URL de la plantilla que hayamos buscado ->
https://ftp.drupal.org/files/projects/adminimal_theme-8.x-1.6.tar.gz
y creamos un poco de contenido:
![PracticaImg](images/iaw/drupalnode1.png "drupal2")

5. **Instala un módulo para añadir alguna funcionalidad a drupal.**

He instalado un nuevo modulo -> https://ftp.drupal.org/files/projects/inline_entity_form-8.x-1.0-rc8.tar.gz
Lo activamos, este modulo se encarga de proporciona un widget para la gestión en línea (creación, modificación, eliminación) de entidades referenciadas.

En este momento, muestra al profesor la aplicación funcionando en local. (4 puntos)

# Tarea 3: Configuración multinodo

* Realiza un copia de seguridad de la base de datos.

```shell
vagrant@drupal:~$ mysqldump -v --opt --events --routines --triggers --default-character-set=utf8 -u fmadu -p fmadudb > fmadu.sql
Enter password: 
-- Connecting to localhost...
-- Disconnecting from localhost...
vagrant@drupal:~$ ls
fmadu.sql
```

* Crea otra máquina con vagrant, conectada con una red interna a la anterior y configura un servidor de base de datos.

Creamos una máquina nueva con vagrant
```shell
 bdd.vm.box = "debian/buster64"
 bdd.vm.hostname = "bdd"
 bdd.vm.network :public_network,:bridge=>"wlo1"
 bdd.vm.network :private_network, ip: "192.168.100.6", virtualbox__intnet: "drupal"
```

* Crea un usuario en la base de datos para trabajar con la nueva base de datos.
```shell
Creamos un usuario en el nuevo servidor:

vagrant@bdd:~$ sudo mysql -u root -p

MariaDB [(none)]> create user 'drupal2' identified by 'dios';

MariaDB [(none)]> grant all privileges on *.* to 'drupal2'@'localhost' identified by 'dios' with grant option;

MariaDB [(none)]> create database 'drupal2_db';

Ahora le damos permisos también a la máquina con drupal:

MariaDB [(none)]> grant all on drupal2_db.* to drupal2@192.168.2.171 identified by 'dios';
```

* Restaura la copia de seguridad en el nuevo servidor de base datos.
He usado git para pasar el archivo de una maquina a otra.
```shell
mysql -u drupal2 --password=dios drupal2_db < /home/vagrant/prueba/fmadu.sql 
```

* Desinstala el servidor de base de datos en el servidor principal.
```shell
vagrant@drupal:~$ sudo apt purge mariadb-*
```

* Realiza los cambios de configuración necesario en drupal para que la página funcione.

Modificamos el fichero 50-server.cnf
```shell
vagrant@drupal2:~$ sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf 

bind-address            = 0.0.0.0
```

Nos vamos a nuestra maquina drupal, en drupal.conf:
```shell
        ServerName www.madu-drupal.org

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/drupal

        <Directory /var/www/drupal>
                Options FollowSymLinks
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>
```

```shell
vagrant@drupal:/var/www/drupal/sites/default$ sudo nano settings.php 

$databases['default']['default'] = array (
  'database' => 'drupal2_db',
  'username' => 'drupal2',
  'password' => 'dios',
  'prefix' => '',
  'host' => '192.168.2.63,
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);
```

# Tarea 4: Instalación de otro CMS PHP.

* Elige otro CMS realizado en PHP y realiza la instalación en tu infraestructura.
```shell
vagrant@drupal:/var/www$ sudo wget https://downloads.joomla.org/es/cms/joomla3/3-9-22/Joomla_3-9-22-Stable-Full_Package.zip?format=zip
vagrant@drupal:/var/www/joomla$ ls
 administrator   cli            images      installation                                        layouts       media     README.txt        tmp
 bin             components     includes   'Joomla_3-9-22-Stable-Full_Package.zip?format=zip'   libraries     modules   robots.txt.dist   web.config.txt
 cache           htaccess.txt   index.php   language  
vagrant@drupal:/var/www$ sudo chown -R www-data:www-data joomla/
```

```shell
vagrant@drupal:/etc/apache2/sites-available$ sudo cp drupal.conf joomla.conf
        ServerName www.madu-joomla.org

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/joomla
        <Directory /var/www/joomla>
                AllowOverride all
        </Directory>
vagrant@drupal:/etc/apache2/sites-available$ sudo a2ensite joomla.conf 
vagrant@drupal:/etc/apache2/sites-available$ sudo systemctl reload apache2
```

Creamos base de datos para joomla
```shell
vagrant@drupal:/etc/apache2/sites-available$ sudo mysql -u fmadu -p

MariaDB [(none)]> create database fmadudbjoomla;
Query OK, 1 row affected (0.017 sec)

MariaDB [(none)]> create user 'joomla1' identified by 'dios';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> grant all on fmadudbjoomla.* to joomla1 identified by 'joomla1'
    -> ;
Query OK, 0 rows affected (0.014 sec)
```

* Configura otro virtualhost y elige otro nombre en el mismo dominio.
En mi maquina ->
```shell
192.168.100.5   www.madu-drupal.org
192.168.100.5   www.madu-joomla.org
```

![PracticaImg](images/iaw/joomla.png "joomla1")
![PracticaImg](images/iaw/joomla2.png "joomla2")

# Tarea 5: Necesidad de otros servicios.

La mayoría de los CMS tienen la posibilidad de mandar correos electrónicos (por ejemplo para notificar una nueva versión, notificar un comentario,…)

* Instala un servidor de correo electrónico en tu servidor. debes configurar un servidor relay de correo, para ello en el fichero /etc/postfix/main.cf, debes poner la siguiente línea:
      relayhost = babuino-smtp.gonzalonazareno.org
```shell
vagrant@drupal:/var/www/joomla$ sudo apt install postfix
```

Selecciono Internet site y luego pongo un correo -> madu.gonzalonazareno.org

En /etc/postfix/main.cf:
```shell
smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = drupal
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination = $myhostname, madu.gonzalonazareno.org, drupal, localhost.localdomain, localhost
relayhost = babuino-smtp.gonzalonazareno.org
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = all
```

Se inicia el servicio.
```shell
vagrant@drupal:/var/www/joomla$ sudo systemctl start postfix
vagrant@drupal:/var/www/joomla$ mailq
Mail queue is empty
```

* Configura alguno de los CMS para utilizar tu servidor de correo y realiza una prueba de funcionamiento.
```shell
vagrant@drupal:/var/www/joomla$ mailq
-Queue ID-  --Size-- ----Arrival Time---- -Sender/Recipient-------
041EF62200      706 Mon Nov  2 16:13:19  frandh1997@gmail.com
(connect to babuino-smtp.gonzalonazareno.org[80.59.1.152]:25: Connection timed out)
                                         frandh1997@gmail.com

01D1B623E7      993 Mon Nov  2 16:13:18  frandh1997@gmail.com
(connect to babuino-smtp.gonzalonazareno.org[80.59.1.152]:25: Connection timed out)
                                         frangodh97@gmail.com

-- 1 Kbytes in 2 Requests.
```

 se deberian enviar esos mensajes de nuevo usuarios, al no estar conectados a la red con babuino no se pueden enviar
