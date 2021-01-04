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

## Servidor DNS

**Instalación de Bind9**
```shell
debian@freston:~$ sudo apt-get install bind9
```

**Configuración del Bind9**

En /etc/bind/named.conf:
```shell
#comentar
// include "/etc/bind/named.conf.default-zones";
```

En /etc/bind/named.conf.local
```shell
view interna {
    match-clients { 10.0.1.0/24; };
    allow-recursion { any; };

        zone "madu.gonzalonazareno.org"
        {
                type master;
                file "db.interna.gonzalonazareno.org";
        };
        zone "1.0.10.in-addr.arpa"
        {
                type master;
                file "db.1.0.10";
        };
        zone "2.0.10.in-addr.arpa"
        {
                type master;
                file "db.2.0.10";
        };
        include "/etc/bind/zones.rfc1918";
        include "/etc/bind/named.conf.default-zones";
};

view externa {
    match-clients { 172.22.0.0/15;  192.168.202.2;};
    allow-recursion { any; };

        zone "madu.gonzalonazareno.org"
        {
                type master;
                file "db.externa.gonzalonazareno.org";
        };
        include "/etc/bind/zones.rfc1918";
        include "/etc/bind/named.conf.default-zones";
};

view dmz {
    match-clients { 10.0.2.0/24; };
    allow-recursion { any; };

        zone "madu.gonzalonazareno.org"
        {
                type master;
                file "db.dmz.gonzalonazareno.org";
        };
        zone "2.0.10.in-addr.arpa"
        {
                type master;
                file "db.2.0.10";
        };
        zone "1.0.10.in-addr.arpa"
        {
                type master;
                file "db.1.0.10";
        };
        include "/etc/bind/zones.rfc1918";
        include "/etc/bind/named.conf.default-zones";
};
```

Creamos las zonas en /var/cache/bind
```shell
#fichero db.interna.gonzalonazareno.org
$TTL    86400
@   IN  SOA freston.madu.gonzalonazareno.org. frandh1997.gonzalonazareno.org. {
                  1     ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
              86400 )   ; Negative Cache TTL
;
@               IN  NS  freston.madu.gonzalonazareno.org.

$ORIGIN madu.gonzalonazareno.org.
dulcinea        IN      A       10.0.1.8
sancho          IN      A       10.0.1.7
freston         IN      A       10.0.1.14
quijote         IN      A       10.0.2.3
www             IN      CNAME   quijote
bd              IN      CNAME   sancho
```

```shell
#fichero db.externa.gonzalonazareno.org
$TTL    86400
@   IN  SOA freston.madu.gonzalonazareno.org. frandh1997.gonzalonazareno.org. {
                  1     ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
              86400 )   ; Negative Cache TTL
;
@               IN      NS      dulcinea.madu.gonzalonazareno.org.

$ORIGIN madu.gonzalonazareno.org.
dulcinea        IN      A       172.22.201.13
www             IN      CNAME   dulcinea
```

```shell
#fichero db.dmz.gonzalonazareno.org
$TTL    86400
@   IN  SOA freston.madu.gonzalonazareno.org. frandh1997.gonzalonazareno.org. {
                  1     ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
              86400 )   ; Negative Cache TTL
;
@               IN      NS      freston.madu.gonzalonazareno.org.

$ORIGIN madu.gonzalonazareno.org.
dulcinea        IN      A       10.0.2.7
sancho          IN      A       10.0.1.7
freston         IN      A       10.0.1.14
quijote         IN      A       10.0.2.3
www             IN      CNAME   quijote
bd              IN      CNAME   sancho
```

```shell
#fichero db.1.0.10
$TTL    86400
@   IN  SOA freston.madu.gonzalonazareno.org. frandh1997.gonzalonazareno.org. {
                  1     ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
              86400 )   ; Negative Cache TTL
;
@                       IN      NS  freston.madu.gonzalonazareno.org.

$ORIGIN 1.0.10.in-addr.arpa.
8       IN      PTR     dulcinea.madu.gonzalonazareno.org.
7      IN      PTR     sancho.madu.gonzalonazareno.org.
14      IN      PTR     freston.madu.gonzalonazareno.org.
```

```shell
#fichero db.2.0.10
$TTL    86400
@   IN  SOA freston.madu.gonzalonazareno.org. frandh1997.gonzalonazareno.org. {
                  1     ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
              86400 )   ; Negative Cache TTL
;
@                       IN      NS  freston.madu.gonzalonazareno.org.

$ORIGIN 2.0.10.in-addr.arpa.
3      IN      PTR     quijote.madu.gonzalonazareno.org.
7      IN      PTR     dulcinea.madu.gonzalonazareno.org.
```

Reglas DNAT en Dulcinea.
```shell
debian@dulcinea:~$ sudo iptables -t nat -A PREROUTING -p udp --dport 53 -i eth1 -j DNAT --to 10.0.1.10
debian@dulcinea:~$ sudo iptables -t nat -A PREROUTING -p tcp --dport 53 -i eth1 -j DNAT --to 10.0.1.10
```

**Comprobaciones**

```shell
#red interna
debian@francisco-madu:~$ dig sancho.madu.gonzalonazareno.org

debian@francisco-madu:~$ dig quijote.madu.gonzalonazareno.org

debian@francisco-madu:~$ dig freston.madu.gonzalonazareno.org
```

```shell
#red externa
fran@debian:~$ dig @10.0.0.8 dulcinea.madu.gonzalonazareno.org

```

```shell
#dmz
[centos@quijote ~]$ dig dulcinea.madu.gonzalonazareno.org



```

```shell
#resoluciones inversas
[centos@quijote]$ dig -x 10.0.1.7

debian@francisco-madu:~$ dig -x 10.0.1.14
```
























**Modificación del FQDN y el DNS.**

Delegación de zona a Papion.



## Servidor Web
En quijote (CentOs)(Servidor que está en la DMZ) vamos a instalar un servidor web apache. Configura el servidor para que sea capaz de ejecutar código php (para ello vamos a usar un servidor de aplicaciones php-fpm). Entrega una captura de pantalla accediendo a www.tunombre.gonzalonazareno.org/info.php donde se vea la salida del fichero info.php. Investiga la reglas DNAT de cortafuegos que tienes que configurar en dulcinea para, cuando accedemos a la IP flotante se acceda al servidor web.

**Instalación del servidor.**
```shell
[centos@quijote ~]$ sudo yum install mariadb-server

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
[centos@quijote ~]$ sudo yum install mariadb-server
[centos@quijote ~]$ sudo systemctl status mariadb
● mariadb.service - MariaDB 10.3 database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
     Docs: man:mysqld(8)
           https://mariadb.com/kb/en/library/systemd/
[centos@quijote ~]$ sudo systemctl start mariadb
[centos@quijote ~]$ sudo systemctl status mariadb
● mariadb.service - MariaDB 10.3 database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2020-12-17 12:32:10 UTC; 4s ago
     Docs: man:mysqld(8)
           https://mariadb.com/kb/en/library/systemd/
  Process: 16693 ExecStartPost=/usr/libexec/mysql-check-upgrade (code=exited, status=0/SUCCESS)
  Process: 16558 ExecStartPre=/usr/libexec/mysql-prepare-db-dir mariadb.service (code=exited, status=0/SUCCESS)
  Process: 16534 ExecStartPre=/usr/libexec/mysql-check-socket (code=exited, status=0/SUCCESS)
 Main PID: 16661 (mysqld)
   Status: "Taking your SQL requests now..."
    Tasks: 30 (limit: 2812)
   Memory: 99.8M
   CGroup: /system.slice/mariadb.service
           └─16661 /usr/libexec/mysqld --basedir=/usr


```