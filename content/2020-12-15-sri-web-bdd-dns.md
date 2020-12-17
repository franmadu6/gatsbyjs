---
date: 2020-12-15
title: "OpenStack: Servidores Web, Base de Datos y DNS"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - SRI
tags:
    - OpenStack
    - Servidor Web
    - Base de datos
    - DNS
---

https://dit.gonzalonazareno.org/redmine/projects/asir2/wiki/Servidores_Web_y_DNS

vista externa (172.22.0.0/15)
    zona resolución directa
        dulcinea 172.22.x.x
        www cname dulcinea
    zona resolucón inversa
        no tiene

vista interna (10.0.1.0/24)
    zona resolución directa
        dulcinea 10.0.1.X
        sancho 10.0.1.X
        quijote 10.0.2.X
        www cname quijote
        bd cname sancho

    zona resolución inversa
        2 zonas : una para 10.0.1.0/24 y otra para 10.0.2.0/24

vista dmz(10.0.2.0/24)
    zona resolución directa
        NS freston
        dulcinea 10.0.2.X
        sancho 10.0.1.X
        quijote 10.0.2.X
        www cname quijote
        bd cname sancho


1 configuro bind con vistas
2 regla dnat en dulcinea para redirigir trafico dns a freston
3 pruebo bind con clientes en las distintas redes


## Servidor DNS

****
```shell

```


## Servidor Web
En quijote (CentOs)(Servidor que está en la DMZ) vamos a instalar un servidor web apache. Configura el servidor para que sea capaz de ejecutar código php (para ello vamos a usar un servidor de aplicaciones php-fpm). Entrega una captura de pantalla accediendo a www.tunombre.gonzalonazareno.org/info.php donde se vea la salida del fichero info.php. Investiga la reglas DNAT de cortafuegos que tienes que configurar en dulcinea para, cuando accedemos a la IP flotante se acceda al servidor web.

**Instalación del servidor.**
```shell

```

**Configuración del uso de php.**
```shell

```

**Configuración del fichero apache2.**
```shell

```

**Accediendo a www.tunombre.gonzalonazareno.org/info.php**
```shell

```

**Investiga la reglas DNAT de cortafuegos que tienes que configurar en dulcinea para, cuando accedemos a la IP flotante se acceda al servidor web.**
```shell

```




## Servidor de base de datos
En sancho (Ubuntu) vamos a instalar un servidor de base de datos mariadb (bd.tu_nombre.gonzalonazareno.org). Entrega una prueba de funcionamiento donde se vea como se realiza una conexión a la base de datos desde quijote.

**Instalación del servidor.**
```shell
ubuntu@sancho:~$ sudo apt install mariadb-server
ubuntu@sancho:~$ sudo mysql_secure_installation
```

**Configuración de Mariadb.**
```shell
ubuntu@sancho:~$ sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf 
#modificamos la linea bind-address
bind-address            = 0.0.0.0
```

**Creación de usuario remoto.**
```shell
sudo mysql -u root
CREATE USER 'maduremote'@'%' IDENTIFIED BY 'madu';
GRANT ALL PRIVILEGES ON *.* TO 'maduremote'@'%';
FLUSH PRIVILEGES;
exit
```

**Creación de la base de datos.**

Nos descargaremos una base de datos de prueba llama world.sql
```shell
MariaDB [(none)]> create database world;
ubuntu@sancho:~$ sudo mysql -u maduremote -p world < world.sql
MariaDB [world]> show tables;
+-----------------+
| Tables_in_world |
+-----------------+
| city            |
| country         |
| countrylanguage |
+-----------------+
3 rows in set (0.001 sec)
MariaDB [world]> select * from city;
+------+------------------------------------+-------------+------------------------+------------+
| ID   | Name                               | CountryCode | District               | Population |
+------+------------------------------------+-------------+------------------------+------------+
|    1 | Kabul                              | AFG         | Kabol                  |    1780000 |
|    2 | Qandahar                           | AFG         | Qandahar               |     237500 |
|    3 | Herat                              | AFG         | Herat                  |     186800 |
|    4 | Mazar-e-Sharif                     | AFG         | Balkh                  |     127800 |
|    5 | Amsterdam                          | NLD         | Noord-Holland          |     731200 |
|    6 | Rotterdam                          | NLD         | Zuid-Holland           |     593321 |
|    7 | Haag                               | NLD         | Zuid-Holland           |     440900 |
|    8 | Utrecht                            | NLD         | Utrecht                |     234323 |
|    9 | Eindhoven                          | NLD         | Noord-Brabant          |     201843 |
...
```

**Prueba de funcionamiento.**
```shell

```