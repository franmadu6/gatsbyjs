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

Para los servidores de oracle he contado con dos maquinas centos7 y el oracle que utilizare en ellas sera el 12C, se llamarán oracle1 y oracle2.

**Configuración Oracle Servidor**

```shell
[root@oracle1 vagrant]# nano /opt/oracle/product/12.2.0.1/dbhome_1/network/admin/listener.ora 
SID_LIST_LISTENER=
  (SID_LIST=
    (SID_DESC=
      (GLOBAL_DBNAME=orcl)
      (ORACLE_HOME=/u01/app/oracle/product/12.2.0.1/dbhome_1)
      (SID_NAME=orcl))
  )

LISTENER =
(DESCRIPTION_LIST =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    (ADDRESS = (PROTOCOL = TCP)(HOST = 172.22.6.156)(PORT = 1521))
  )
) 
```

**Configuración Oracle Cliente**

```shell
[root@localhost vagrant]# nano /opt/oracle/product/12.2.0.1/dbhome_1/network/admin/tnsnames.ora
LISTENER_ORCL =
 (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))

ORCL =
 (DESCRIPTION = Mi Servidor Oracle
    (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
    (CONNECT_DATA =
        (SERVER = DEDICATED)
        (SERVICE_NAME = orcl)
    )
 )

OracleServer =
 (DESCRIPTION = Servidor Oracle1
    (ADDRESS = (PROTOCOL = TCP)(HOST = 172.22.8.230)(PORT = 1521))
    (CONNECT_DATA =
        (SERVER = DEDICATED)
        (SERVICE_NAME = orcl2)
    )
```

**Reiniciaremos el servicio**
* lsnrctl stop: Detenemos el servicio.
* lsnrctl start: Iniciamos el servicio de nuevo.

```shell
[oracle@localhost ~]$ lsnrctl stop

LSNRCTL for Linux: Version 12.2.0.1.0 - Production on 25-FEB-2021 05:01:05

Copyright (c) 1991, 2016, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1)))
The command completed successfully
[oracle@localhost ~]$ lsnrctl start

LSNRCTL for Linux: Version 12.2.0.1.0 - Production on 25-FEB-2021 05:01:10

Copyright (c) 1991, 2016, Oracle.  All rights reserved.

Starting /opt/oracle/product/12.2.0.1/dbhome_1/bin/tnslsnr: please wait...

TNSLSNR for Linux: Version 12.2.0.1.0 - Production
System parameter file is /opt/oracle/product/12.2.0.1/dbhome_1/network/admin/listener.ora
Log messages written to /opt/oracle/diag/tnslsnr/localhost/listener/alert/log.xml
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1)))
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 12.2.0.1.0 - Production
Start Date                25-FEB-2021 05:01:10
Uptime                    0 days 0 hr. 0 min. 0 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/oracle/product/12.2.0.1/dbhome_1/network/admin/listener.ora
Listener Log File         /opt/oracle/diag/tnslsnr/localhost/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))
Services Summary...
Service "orcl2" has 1 instance(s).
  Instance "orcl2", status UNKNOWN, has 1 handler(s) for this service...
```

**Creación de Usuario**

En el servidor.
```shell
[oracle@oracle1 ~]$ sqlplus / AS SYSDBA

SQL*Plus: Release 12.2.0.1.0 Production on Thu Feb 25 05:08:55 2021

Copyright (c) 1982, 2016, Oracle.  All rights reserved.


Connected to:
Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production

SQL> create user usuariosv identified by fran;

User created.

SQL> grant create database link to usuariosv;

Grant succeeded.

#le daremos permisos y accederemos a oracle con la cuenta creada.

SQL> create database link cliente
  2  connect to usuariocliente
  3  identified by fran
  4  using 'orcl2';

Database link created.

select color,clave from perros@cliente , prueba;
COLOR			  CLAVE
------------------------- -------------------------
Blanco	 		  Podadora
Negro  			  Pepito            
```

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

bdd1=> bdd1=> SELECT * FROM dblink('dbname=bdd2 host=172.22.3.40 user=postgres2 password=fran', 'select * from profesores') AS profesores (dni varchar, nombre varchar, apellido varchar, despacho varchar, telefono varchar);
    dni    |    nombre    |     apellido     | despacho | telefono  
-----------+--------------+------------------+----------+-----------
 36987412P | David        | Moreno Cruz      | 01       | 614576324
 69874510G | José Antonio | Fernández Antona | 02       | 655590038
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

```shell
vagrant@postgres2:~$ psql -h localhost -U postgres2 -W -d bdd2
Password: 
psql (11.10 (Debian 11.10-0+deb10u1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

bdd2=> SELECT * FROM dblink('dbname=bdd1 host=172.22.5.30 user=postgres1 password=fran', 'select * from profesores') AS profesores (dni varchar, nombre varchar, apellido varchar, despacho varchar, telefono varchar);
    dni    |    nombre    |     apellido     | despacho | telefono  
-----------+--------------+------------------+----------+-----------
 36987412P | David        | Moreno Cruz      | 01       | 614576324
 69874510G | José Antonio | Fernández Antona | 02       | 655590038
 53698745R | Sara         | Serra Macia      | 03       | 674706264
 36789874V | Juan         | López Sirera     | 04       | 681829070
 20247859Q |  Óscar       | Estévez González | 05       | 699906800
 28966631V | José Manuel  | Pérez Fernández  | 06       | 634844973
 45987785K | Manuela      | Rubio Cabello    | 07       | 646837477
 50236558G | Carmen       | Sánchez Carvajal | 08       | 696625669
 46987845H | Joaquín      | Aranda Almansaz  | 09       | 689117250
 22025562A | Lourdes      | Araujo Serna     | 10       | 621561960
 49065878R | Fernando     | Morilla García   | 11       | 685644007
 36587899M | Alfonso      | Urquía Moraleda  | 12       | 633145641
 K5987455X | Antonio      | Moreno Cano      | 04       | 614563124
(13 rows)
```

Como podemos comprobar ya podemos realizar insterconexiones entre ambas maquinas en la bdd2 añadí menos datos a las tablas para que podamos apreciar el cambio de una a otra.

## Enlace entre servidor ORACLE y Postgres o MySQL empleando Heterogeneus Services.

### Oracle a Postgres.

Instalación de la paquetería necesaria.
```shell
[root@oracle1 vagrant]# yum install postgresql-odbc
```

Una vez instalada la paqueteria accederemos al archivo /etc/odbcinst.ini, en el podremos ver los drivers existentes, en nuestro caso nos interesa el de postgres y nos fijaremos en como se llama especificamente.
```shell
[root@oracle1 vagrant]# cat /etc/odbcinst.ini
# Example driver definitions

# Driver from the postgresql-odbc package
# Setup from the unixODBC package
[PostgreSQL]
Description	= ODBC for PostgreSQL
Driver		= /usr/lib/psqlodbcw.so
Setup		= /usr/lib/libodbcpsqlS.so
Driver64	= /usr/lib64/psqlodbcw.so
Setup64		= /usr/lib64/libodbcpsqlS.so
FileUsage	= 1


# Driver from the mysql-connector-odbc package
# Setup from the unixODBC package
[MySQL]
Description	= ODBC for MySQL
Driver		= /usr/lib/libmyodbc5.so
Setup		= /usr/lib/libodbcmyS.so
Driver64	= /usr/lib64/libmyodbc5.so
Setup64		= /usr/lib64/libodbcmyS.so
FileUsage	= 1
```


Crearemos un DSN llamado **odbc.ini** que determinará la conexión al gestor que especifiquemos.
```shell
[root@oracle1 vagrant]# nano /etc/odbc.ini
[PSQLU]
Debug           = 0
CommLog         = 0
ReadOnly        = 0
Driver          = PostgreSQL
Servername	= 172.22.3.40  
Username        = postgres2     
Password        = fran   
Port            = 5432
Database        = bdd2   
Trace           = 0
TraceFile	= /tmp/sql.log
```

Ya tendremos configurado el driver de ODBC, probaremos el resultado.
```shell
[root@oracle1 vagrant]# isql PSQLU
+---------------------------------------+
| Connected!                            |
|                                       |
| sql-statement                         |
| help [tablename]                      |
| quit                                  |
|                                       |
+---------------------------------------+
SQL> select * from profesores;
+----------+----------------+---------------------------------------------------+-----------+----------+
| dni      | nombre         | apellido                                          | despacho  | telefono |
+----------+----------------+---------------------------------------------------+-----------+----------+
| 36987412P| David          | Moreno Cruz                                       | 01        | 614576324|
| 69874510G| José Antonio  | Fernández Antona                                 | 02        | 655590038|
+----------+----------------+---------------------------------------------------+-----------+----------+
SQLRowCount returns 2
2 rows fetched
SQL> create table coches(nombre varchar(10));
SQLRowCount returns 0
SQL> select * from coches;
+-----------+
| nombre    |
+-----------+
+-----------+
SQLRowCount returns 0
SQL> insert into coches (nombre) values ('Ferrari');
SQLRowCount returns 1
SQL> select * from coches;
+-----------+
| nombre    |
+-----------+
| Ferrari   |
+-----------+
SQLRowCount returns 1
1 rows fetched
```

Como podemos comprobar la configuración del driver ha sido exitosa, ahora procederemos a configurar Oracle para que pueda usar dicho driver exitosamente.


**Heterogeneous Services**  
Es un componente dentro del servidor de base de datos de Oracle que se requiere para acceder a un sistema de base de datos que no es de Oracle. 

Generaremos el siguiente fichero:
```shell
[oracle@oracle1 ~]$ nano /opt/oracle/product/12.2.0.1/dbhome_1/hs/admin/initPSQLU.ora
HS_FDS_CONNECT_INFO = PSQLU
HS_FDS_TRACE_LEVEL = DEBUG
HS_FDS_SHAREABLE_NAME = /usr/lib64/psqlodbcw.so
HS_LANGUAGE = AMERICAN_AMERICA.WE8ISO8859P1
set ODBCINI=/etc/odbc.ini
```

Configuráremos el listener para que escuche peticiones hacia el driver ODBC:
```shell
[root@oracle1 vagrant]# nano /opt/oracle/product/12.2.0.1/dbhome_1/network/admin/listener.ora
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
  )

SID_LIST_LISTENER=
  (SID_LIST=
      (SID_DESC=
         (SID_NAME=PSQLU)
         (ORACLE_HOME=/opt/oracle/product/12.2.0.1/dbhome_1)
         (PROGRAM=dg4odbc)
      )
  )
```

Modifiraremos el fichero de nombre que facilita el acceso a servidores remotos.
```shell
[root@oracle1 vagrant]# nano /opt/oracle/product/12.2.0.1/dbhome_1/network/admin/tnsnames.ora 
PSQLU  =
  (DESCRIPTION=
    (ADDRESS=(PROTOCOL=tcp)(HOST=localhost)(PORT=1521))
    (CONNECT_DATA=(SID=PSQLU))
    (HS=OK)
  )
```

Accederemos al usuario Oracle de nuestro sistema y reiniciaremos el proceso de listener:
```shell
[oracle@oracle1 ~]$ lsnrctl stop

LSNRCTL for Linux: Version 12.2.0.1.0 - Production on 25-FEB-2021 08:48:28

Copyright (c) 1991, 2016, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521)))
The command completed successfully
[oracle@oracle1 ~]$ lsnrctl start

LSNRCTL for Linux: Version 12.2.0.1.0 - Production on 25-FEB-2021 08:48:30

Copyright (c) 1991, 2016, Oracle.  All rights reserved.

Starting /opt/oracle/product/12.2.0.1/dbhome_1/bin/tnslsnr: please wait...

TNSLSNR for Linux: Version 12.2.0.1.0 - Production
System parameter file is /opt/oracle/product/12.2.0.1/dbhome_1/network/admin/listener.ora
Log messages written to /opt/oracle/diag/tnslsnr/oracle1/listener/alert/log.xml
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=oracle1)(PORT=1521)))
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 12.2.0.1.0 - Production
Start Date                25-FEB-2021 08:48:31
Uptime                    0 days 0 hr. 0 min. 8 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/oracle/product/12.2.0.1/dbhome_1/network/admin/listener.ora
Listener Log File         /opt/oracle/diag/tnslsnr/oracle1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=oracle1)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
Services Summary...
Service "PSQLU" has 1 instance(s).
  Instance "PSQLU", status UNKNOWN, has 1 handler(s) for this service...
The command completed successfully
```

Accederemos a nuestro usuario de oracle y crearemos un enlace para comprobar la configuración.
```shell
SQL> create database link postgresconn
  2  connect to "postgres2" identified by "fran"
  3  using 'PSQLU';

Database link created.

SQL> select * from coches@postgresconn;

NOMBRE
-------------------------
Ferrari
```

### Postgres a Oracle.

Instalamos la paquetería requerida.
```shell
root@postgres2:/home/vagrant# apt install libaio1 postgresql-server-dev-all build-essential git
```

Accederemos al usuario postgres y descargaremos los paquetes del sitio oficial de Oracle:
```shell
vagrant@postgres2:~$ su - postgres 
Password: 
postgres@postgres2:~$
postgres@postgres2:~$ wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip
postgres@postgres2:~$ wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sdk-linux.x64-21.1.0.0.0.zip
postgres@postgres2:~$ wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sqlplus-linux.x64-21.1.0.0.0.zip
```

Descomprimiremos los archivos con unzip.
```shell
postgres@postgres2:~$ unzip instantclient-basic-linux.x64-21.1.0.0.0.zip
postgres@postgres2:~$ unzip instantclient-sqlplus-linux.x64-21.1.0.0.0.zip
postgres@postgres2:~$ unzip instantclient-sdk-linux.x64-21.1.0.0.0.zip
```

Despues de descomprimir los 3 archivos se nos creará una carpeta llamada instantclient_21_1.

Estableceremos las nuevas variables de entorno:
```shell
postgres@postgres2:~$  export ORACLE_HOME=/var/lib/postgresql/instantclient_21_1
postgres@postgres2:~$  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME
postgres@postgres2:~$  export PATH=$PATH:$ORACLE_HOME
```

Para comprobar si hemos puesto correctamente las variables utilizaremos el comando wich que nos deberá devolver la ruta.
```shell
postgres@postgres2:/var/lib$ which sqlplus
/var/lib/postgresql/instantclient_21_1/sqlplus
```

```shell
postgres@postgres2:~$ sqlplus usuariosv/fran@192.168.2.124/ORCL

SQL*Plus: Release 21.0.0.0.0 - Production on Thu Feb 25 19:51:07 2021
Version 21.1.0.0.0

Copyright (c) 1982, 2020, Oracle.  All rights reserved.

Last Successful login time: Thu Feb 25 2021 19:48:17 +00:00

Connected to:
Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production

SQL> select * from prueba;

NOMBRE			  CLAVE
------------------------- -------------------------
Mariano 		  Podadora
```