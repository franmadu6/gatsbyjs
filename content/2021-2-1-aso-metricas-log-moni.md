---
date: 2021-02-01
title: "Métricas, logs o monitorización"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - ASO
tags:
    - Métricas
    - Logs
    - Monitorización
    - Graphite
    - Grafana
    - Centreon
---

# Zabbix

<center><img alt="Guacamole" src="https://www.icm.es/wp-content/uploads/2020/04/logo-zabbix-768x554.jpg"/></center>

## Fase previa a la instalación de Zabbix para Debian10

El repositorio se instala a través de un paquete .deb que podemos descargar desde consola:
```shell
debian@freston:~$ wget https://repo.zabbix.com/zabbix/4.4/debian/pool/main/z/zabbix-release/zabbix-release_4.4-1+buster_all.deb
--2021-02-03 13:57:02--  https://repo.zabbix.com/zabbix/4.4/debian/pool/main/z/zabbix-release/zabbix-release_4.4-1+buster_all.deb
Resolving repo.zabbix.com (repo.zabbix.com)... 178.128.6.101, 2604:a880:2:d0::2062:d001
Connecting to repo.zabbix.com (repo.zabbix.com)|178.128.6.101|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 4116 (4.0K) [application/octet-stream]
Saving to: ‘zabbix-release_4.4-1+buster_all.deb’

zabbix-release_4.4-1+ 100%[=======================>]   4.02K  --.-KB/s    in 0s      

2021-02-03 13:57:04 (65.1 MB/s) - ‘zabbix-release_4.4-1+buster_all.deb’ saved [4116/4116]
```

Instalamos el paquete.
```shell
debian@freston:~$ sudo dpkg -i zabbix-release_4.4-1+buster_all.deb
Selecting previously unselected package zabbix-release.
(Reading database ... 28410 files and directories currently installed.)
Preparing to unpack zabbix-release_4.4-1+buster_all.deb ...
Unpacking zabbix-release (1:4.4-1+buster) ...
Setting up zabbix-release (1:4.4-1+buster) ...
```

Actualizamos nuestros repositorios.
```shell
debian@freston:~$ sudo apt update
Get:1 http://repo.zabbix.com/zabbix/4.4/debian buster InRelease [7,096 B]
Get:2 http://repo.zabbix.com/zabbix/4.4/debian buster/main Sources [1,214 B]        
Get:3 http://repo.zabbix.com/zabbix/4.4/debian buster/main amd64 Packages [4,805 B]  
Hit:4 http://deb.debian.org/debian buster InRelease                                  
Get:5 http://security.debian.org/debian-security buster/updates InRelease [65.4 kB] 
Get:6 http://deb.debian.org/debian buster-updates InRelease [51.9 kB]
Get:7 http://deb.debian.org/debian buster-updates/main Sources.diff/Index [5,164 B]
Get:8 http://security.debian.org/debian-security buster/updates/main Sources [177 kB]
Get:9 http://deb.debian.org/debian buster-updates/main amd64 Packages.diff/Index [5,164 B]
Get:10 http://security.debian.org/debian-security buster/updates/main amd64 Packages [266 kB]
Get:11 http://deb.debian.org/debian buster-updates/main Sources 2021-01-29-2000.47.pdiff [653 B]
Get:11 http://deb.debian.org/debian buster-updates/main Sources 2021-01-29-2000.47.pdiff [653 B]
Get:12 http://security.debian.org/debian-security buster/updates/main Translation-en [142 kB]
Get:13 http://deb.debian.org/debian buster-updates/main amd64 Packages 2021-01-29-2000.47.pdiff [408 B]
Get:13 http://deb.debian.org/debian buster-updates/main amd64 Packages 2021-01-29-2000.47.pdiff [408 B]
Fetched 726 kB in 3s (255 kB/s)                         
Reading package lists... Done
Building dependency tree       
Reading state information... Done
4 packages can be upgraded. Run 'apt list --upgradable' to see them.
```

## Instalación de Zabbix

Usaremos MariaDB como motor de bases de datos, instalaremos los paquetes zabbix-server-mysql, zabbix-frontend-php, zabbix-agent:
```shell
debian@freston:~$ sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-agent zabbix-apache-conf
Reading package lists... Done
Building dependency tree       
Reading state information... Done

Creating config file /etc/php/7.3/apache2/php.ini with new version
Module mpm_event disabled.
Enabling module mpm_prefork.
apache2_switch_mpm Switch to prefork
apache2_invoke: Enable module php7.3
Setting up libhtml-template-perl (2.97-1) ...
Setting up libapache2-mod-php (2:7.3+69) ...
Setting up zabbix-apache-conf (1:4.4.10-1+buster) ...
Enabling conf zabbix.
To activate the new configuration, you need to run:
  systemctl reload apache2
Setting up libcgi-fast-perl (1:2.13-1) ...
Processing triggers for systemd (241-7~deb10u5) ...
Processing triggers for libc-bin (2.28-10) ...
```

Recargamos la configuración de nuestro servidor web:
```shell
debian@freston:~$ sudo systemctl reload apache2
```

## Preparación de la Base de datos

Zabbix necesita una bdd y un usuarios con permisos en ella, asi que procederemos a su creación.
```shell
debian@freston:~$ sudo mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 49
Server version: 10.3.27-MariaDB-0+deb10u1 Debian 10

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> create database zabbix;
Query OK, 1 row affected (0.000 sec)

MariaDB [(none)]> create user zabbix@localhost identified by 'fran';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> grant all privileges on zabbix.* to zabbix@localhost;
Query OK, 0 rows affected (0.000 sec)

MariaDB [(none)]> flush privileges;
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> exit
Bye
```

En otras aplicaciones es el propio instalador el que crea la estructura incial de la base de datos y la puebla con los datos iniciales. Sin embargo, en Zabbix el proceso lo haremos de forma manual, importando un archivo preparado al efecto:
```shell
debian@freston:~$ zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql zabbix -u zabbix -p
Enter password: 
```

## Configuración de Zabbix Server








iptables -A INPUT -p tcp -m tcp --dport 10050 -j ACCEPT