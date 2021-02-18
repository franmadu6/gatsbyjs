---
date: 2021-02-11
title: "[ABD] - Interconexión de Servidores de Bases de Datos"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - ABD
tags:
    - Interconexión de Servidores
---

<center><img alt="Interconexión de Servidores" src="https://www.juanluramirez.com/wp-content/uploads/2016/12/Portada-1.jpg"/></center>

Las interconexiones de servidores de bases de datos son operaciones que pueden ser muy útiles en diferentes contextos. Básicamente, se trata de acceder a datos que no están almacenados en nuestra base de datos, pudiendo combinarlos con los que ya tenemos.

En esta práctica veremos varias formas de crear un enlace entre distintos servidores de bases de datos.

Se pide:

* Realizar un enlace entre dos servidores de bases de datos ORACLE, explicando la configuración necesaria en ambos extremos y demostrando su funcionamiento.
      
* Realizar un enlace entre dos servidores de bases de datos Postgres, explicando la configuración necesaria en ambos extremos y demostrando su funcionamiento.
      
* Realizar un enlace entre un servidor ORACLE y otro Postgres o MySQL empleando Heterogeneus Services, explicando la configuración necesaria en ambos extremos y demostrando su funcionamiento.

Los servidores enlazados siempre tendrán que estar instalados en máquinas diferentes.

## Enlace entre servidores ORACLE.


## Enlace entre servidores Postgres.

### Permitir Accesos Remotos

**Postgres1**
```shell
root@postgres1:/home/vagrant# nano /etc/postgresql/11/main/postgresql.conf 
listen_addresses = '0'
root@postgres1:/home/vagrant# nano /etc/postgresql/11/main/pg_hba.conf 
host     all             all             0.0.0.0/0
root@postgres1:/home/vagrant# systemctl restart postgresql
root@postgres1:/home/vagrant# psql
psql: could not connect to server: No such file or directory
	Is the server running locally and accepting
	connections on Unix domain socket "/var/run/postgresql/.s.PGSQL.5432"?
```

Para solucionar este error deberemos de tirar el cluster y volverlo a crear
```shell
#como podemos comprobar el cluster esta apagado y no lo podemos encender
root@postgres1:/home/vagrant# pg_lsclusters
Ver Cluster Port Status Owner    Data directory              Log file
11  main    5432 down   postgres /var/lib/postgresql/11/main /var/log/postgresql/postgresql-11-main.log
#lo borraremos
root@postgres1:/home/vagrant# pg_dropcluster --stop 11 main
#crearemos uno y lo iniciamos
root@postgres1:/home/vagrant# pg_createcluster --locale es_ES.UTF-8 --start 11 main
Creating new PostgreSQL cluster 11/main ...
/usr/lib/postgresql/11/bin/initdb -D /var/lib/postgresql/11/main --auth-local peer --auth-host md5 --locale es_ES.UTF-8
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with locale "es_ES.UTF-8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "spanish".

Data page checksums are disabled.

fixing permissions on existing directory /var/lib/postgresql/11/main ... ok
creating subdirectories ... ok
selecting default max_connections ... 100
selecting default shared_buffers ... 128MB
selecting default timezone ... UTC
selecting dynamic shared memory implementation ... posix
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok

Success. You can now start the database server using:

    pg_ctlcluster 11 main start

Ver Cluster Port Status Owner    Data directory              Log file
11  main    5432 online postgres /var/lib/postgresql/11/main /var/log/postgresql/postgresql-11-main.log
root@postgres1:/home/vagrant# pg_ctlcluster 11 main start
#como podemos comprobar ya podemos utilizar postgres
root@postgres1:/home/vagrant# sudo -u postgres -i
postgres@postgres1:~$ psql
psql (11.10 (Debian 11.10-0+deb10u1))
Type "help" for help.

postgres=# 
```

**Postgres2**
```shell
root@postgres2:/home/vagrant# nano /etc/postgresql/11/main/postgresql.conf 
listen_addresses = '*'
root@postgres2:/home/vagrant# nano /etc/postgresql/11/main/pg_hba.conf 
host     all             all             0.0.0.0/0
host    all             all             all                     md5
root@postgres2:/home/vagrant# systemctl restart postgresql
```

### Creamos las bases de datos y sus respectivas tablas

**Postgres1**
```shell
postgres=# CREATE USER postgres1 WITH PASSWORD 'fran';
CREATE ROLE
postgres=# CREATE DATABASE bdd1;
CREATE DATABASE
postgres=# GRANT ALL PRIVILEGES ON DATABASE bdd1 to postgres1;
GRANT
```

```shell
postgres@postgres1:~$ psql -h localhost -U postgres1 -W -d bdd1
Password: 
psql (11.10 (Debian 11.10-0+deb10u1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

bdd1=> 
```

```shell
create table profesores(
dni varchar(9),
nombre varchar(15),
apellido varchar(50),
despacho varchar(10),
telefono varchar(9),
constraint pk_dni primary key (dni),
constraint ck_dni check(dni ~ '[0-9]{8}[A-Z]{1}$' or dni ~ '[KLMXYZ]{1}[0-9]{7}[A-Z]{1}$')
);
 
insert into profesores
values ('36987412P','David','Moreno Cruz','01','614576324');
insert into profesores
values ('69874510G','José Antonio','Fernández Antona','02','655590038');
insert into profesores
values ('53698745R','Sara ','Serra Macia','03','674706264');
insert into profesores
values ('36789874V','Juan','López Sirera','04','681829070');
insert into profesores
values ('20247859Q',' Óscar','Estévez González','05','699906800');
insert into profesores
values ('28966631V','José Manuel ','Pérez Fernández','06','634844973');
insert into profesores
values ('45987785K','Manuela ','Rubio Cabello','07','646837477');
insert into profesores
values ('50236558G','Carmen','Sánchez Carvajal','08','696625669');
insert into profesores
values ('46987845H','Joaquín','Aranda Almansaz','09','689117250');
insert into profesores
values ('22025562A','Lourdes','Araujo Serna','10','621561960');
insert into profesores
values ('49065878R','Fernando','Morilla García','11','685644007');
insert into profesores
values ('36587899M','Alfonso','Urquía Moraleda','12','633145641');
insert into profesores
values ('K5987455X','Antonio','Moreno Cano','04','614563124');
```

**Postgres2**
```shell
postgres=# CREATE USER postgres2 WITH PASSWORD 'fran';
CREATE ROLE
postgres=# CREATE DATABASE bdd2;
CREATE DATABASE
postgres=# GRANT ALL PRIVILEGES ON DATABASE bdd2 to postgres2;
GRANT
```

```shell
postgres@postgres2:~$ psql -h localhost -U postgres2 -W -d bdd2
Password: 
psql (11.10 (Debian 11.10-0+deb10u1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

bdd2=> 
```

```shell
create table profesores(
dni varchar(9),
nombre varchar(15),
apellido varchar(50),
despacho varchar(10),
telefono varchar(9),
constraint pk_dni primary key (dni),
constraint ck_dni check(dni ~ '[0-9]{8}[A-Z]{1}$' or dni ~ '[KLMXYZ]{1}[0-9]{7}[A-Z]{1}$')
);
 
insert into profesores
values ('36987412P','David','Moreno Cruz','01','614576324');
insert into profesores
values ('69874510G','José Antonio','Fernández Antona','02','655590038');
```

### Interconexiones

postgres1
```shell
postgres@postgres1:~$ psql -d bdd1
psql (11.10 (Debian 11.10-0+deb10u1))
Type "help" for help.

bdd1=# create extension dblink;
CREATE EXTENSION
bdd1=# \q
```

```shell
postgres@postgres1:~$ psql -h localhost -U postgres1 -W -d bdd1
Password: 
psql (11.10 (Debian 11.10-0+deb10u1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

bdd1=> SELECT * FROM dblink('dbname=bdd2 host=192.168.2.255 user=postgres2 password=fran', 'select * from profesores') AS profesores (dni varchar, nombre varchar, apellido varchar, despacho varchar, telefono varchar);
ERROR:  could not establish connection
DETAIL:  no se pudo conectar con el servidor: La red es inaccesible
	¿Está el servidor en ejecución en el servidor «192.168.2.255» y aceptando
	conexiones TCP/IP en el puerto 5432?
```

postgres2
```shell
postgres@postgres2:~$ psql -d bdd2
psql (11.10 (Debian 11.10-0+deb10u1))
Type "help" for help.

bdd2=# create extension dblink;
CREATE EXTENSION
bdd2=# \q
```

## Enlace entre servidor ORACLE y Postgres o MySQL empleando Heterogeneus Services.

