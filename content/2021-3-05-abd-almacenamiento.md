---
date: 2021-03-05
title: "[ABD] - Práctica 6 Almacenamiento"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - ABD
tags:
    - Almacenamiento
---

<center><img alt="Almacenamiento base de datos" src="https://www.ionos.es/digitalguide/fileadmin/DigitalGuide/Teaser/database-t.jpg"/></center>

## ORACLE:

1. Muestra los objetos a los que pertenecen las extensiones del tablespace TS2 (creado por tí) y el tamaño de cada una de ellas. Tendrás que crear objetos en él previamente, claro.

Creamos un tablespace llamado TS2.
```shell
SQL> CREATE TABLESPACE TS2
  2  DATAFILE '/home/oracle/ts2.dbf' 
  3  SIZE 200K
  4  AUTOEXTEND ON
  5  DEFAULT STORAGE (
  6  INITIAL 200K
  7  NEXT 200K
  8  MAXEXTENTS 3
  9  PCTINCREASE 100);

Tablespace created.
```

Como podemos comprobar ya tenemos nuestro tablespace creado y podemos comprobar su ubicación.
```shell
SQL> select file_name,tablespace_name from dba_data_files where tablespace_name='TS2';

FILE_NAME
--------------------------------------------------------------------------------
TABLESPACE_NAME
------------------------------
/home/oracle/ts2.dbf
TS2
```

Crearemos una paqueña prueba para ver el funcionamiento de su espacio.
```shell
SQL> CREATE TABLE pruebats2 (           
  2  MT_CLAVE           NUMBER(3)    NOT NULL,
  3  MT_DESCRIPCION     VARCHAR2(50) NULL
  4  )  TABLESPACE TS2;             

Table created.
```

Le añadiremos un poco de contenido.
```shell
insert into pruebats2 (MT_CLAVE,MT_DESCRIPCION) values ('132','clave prueba1');
insert into pruebats2 (MT_CLAVE,MT_DESCRIPCION) values ('653','clave prueba2');
insert into pruebats2 (MT_CLAVE,MT_DESCRIPCION) values ('178','clave prueba3');
```

Comprobaremos el espacio libre ocupa nuestro tablespace en este momento.
```shell
SQL> SELECT TABLESPACE_NAME,TO_CHAR(SUM(NVL(BYTES,0))/1024/1024, '99,999,990.99') AS "FREE SPACE(IN MB)"
  2  FROM USER_FREE_SPACE 
  3  GROUP BY TABLESPACE_NAME;

TABLESPACE_NAME 	       FREE SPACE(IN
------------------------------ --------------
SYSAUX					28.25
UNDOTBS1				29.31
TS2					 1.06
USERS					 3.94
SYSTEM					 8.81
```

2. Borra la tabla que está llenando TS2 consiguiendo que vuelvan a existir extensiones libres. Añade después otro fichero de datos a TS2.

Borramos la tabla anteriormente creada y verificamos el espacio de almacenamiento de nuestro tablespace.
```shell
SQL> drop table pruebats2;

Table dropped.

SQL> SELECT TABLESPACE_NAME,TO_CHAR(SUM(NVL(BYTES,0))/1024/1024, '99,999,990.99') AS "FREE SPACE(IN MB)"
  2  FROM USER_FREE_SPACE
  3  GROUP BY TABLESPACE_NAME;

TABLESPACE_NAME 	       FREE SPACE(IN
------------------------------ --------------
SYSAUX					28.25
UNDOTBS1				29.31
TS2					 1.13
USERS					 3.94
SYSTEM					 8.81
```

Para empezar visualizaremos los ficheros que estamos usando:
```shell
SQL> select substr(name, 1, 255)
from v$datafile;

SUBSTR(NAME,1,255)
--------------------------------------------------------------------------------
/opt/oracle/oradata/ORCL/system01.dbf
/opt/oracle/oradata/ORCL/sysaux01.dbf
/opt/oracle/oradata/ORCL/undotbs01.dbf
/home/oracle/ts2.dbf
/opt/oracle/oradata/ORCL/users01.dbf
```

Añadiremos un nuevo fichero y comprobamos que se ha añadido a nuestro tablespace.
```shell
SQL> alter tablespace TS2 add datafile '/home/oracle/prueba.dbf' size 10M;

Tablespace altered.

SQL> select file_name,tablespace_name
  2  from dba_data_files
  3  where tablespace_name='TS2';

FILE_NAME
--------------------------------------------------------------------------------
TABLESPACE_NAME
------------------------------
/home/oracle/ts2.dbf
TS2

/home/oracle/prueba.dbf
TS2
```

3. Crea el tablespace TS3 gestionado localmente con un tamaño de extension uniforme de 128K y un fichero de datos asociado. Cambia la ubicación del fichero de datos y modifica la base de datos para que pueda acceder al mismo. Crea en TS3 dos tablas e inserta registros en las mismas. Comprueba que segmentos tiene TS3, qué extensiones tiene cada uno de ellos y en qué ficheros se encuentran.

Crearemos el nuevo tablespace TS3, que tendra un fichero añadido y una extension uniforme de 128K.
```shell
SQL> CREATE TABLESPACE TS3 DATAFILE '/home/oracle/ts3.dbf' SIZE 50M EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K;

Tablespace created.

SQL> select file_name,tablespace_name
  2  from dba_data_files
  3  where tablespace_name='TS3';

FILE_NAME
--------------------------------------------------------------------------------
TABLESPACE_NAME
------------------------------
/home/oracle/ts3.dbf
TS3
```

Para modificar los archivos dentro de un tablespace indicado, primero deberemos apagarlo.
```shell
SQL> ALTER TABLESPACE TS3 OFFLINE ;

Tablespace altered.
```

Ahora procederemos a las modificacion de la ubicación del fichero.
```shell
[oracle@oracle1 ~]$ ls
actividad3  drop.sql  prueba.dbf  setPassword.sh  ts2.dbf  ts3.dbf
[oracle@oracle1 ~]$ mv ts3.dbf actividad3/

SQL> alter tablespace TS3 rename datafile '/home/oracle/ts3.dbf' to '/home/oracle/actividad3/ts3.dbf';

Tablespace altered.
```

Activamos el tablespace y comprobamos la nueva configuración.
```shell
SQL> ALTER TABLESPACE TS3 ONLINE;

Tablespace altered.

SQL> select file_name,tablespace_name
  2  from dba_data_files
  3  where tablespace_name='TS3';

FILE_NAME
--------------------------------------------------------------------------------
TABLESPACE_NAME
------------------------------
/home/oracle/actividad3/ts3.dbf
TS3
```



4. Redimensiona los ficheros asociados a los tres tablespaces que has creado de forma que ocupen el mínimo espacio posible para alojar sus objetos.



5. Crea una secuencia para rellenar el campo deptno de la tabla dept de forma coherente con los datos ya existentes.  Inserta al menos dos registros haciendo uso de la secuencia.



6. Resuelve el siguiente caso práctico en **ORACLE**:
       
En nuestra empresa existen tres departamentos: Informática, Ventas y Producción. En Informática trabajan tres personas: Pepe, Juan y Clara. En Ventas trabajan Ana y Eva y en Producción Jaime y Lidia.

a)
Pepe es el administrador de la base de datos.
Juan y Clara son los programadores de la base de datos, que trabajan tanto en la aplicación que usa el departamento de Ventas como en la usada por el departamento de Producción.
Ana y Eva tienen permisos para insertar, modificar y borrar registros en las tablas de la aplicación de Ventas que tienes que crear, y se llaman Productos y Ventas, siendo propiedad de Ana.
Jaime y Lidia pueden leer la información de esas tablas pero no pueden modificar la información.
Crea los usuarios y dale los roles y permisos que creas conveniente.  


b)
Los espacios de tablas son System, Producción (ficheros prod1.dbf y prod2.dbf) y Ventas (fichero vent.dbf).
Los programadores del departamento de Informática pueden crear objetos en cualquier tablespace de la base de datos, excepto en System.
Los demás usuarios solo podrán crear objetos en su tablespace correspondiente teniendo un límite de espacio de 30 M los del departamento de Ventas y 100K los del de Producción.
Pepe tiene cuota ilimitada en todos los espacios, aunque el suyo por defecto es System.


c)	
Pepe quiere crear una tabla Prueba que ocupe inicialmente 256K en el tablespace Ventas.



d)
Pepe decide que los programadores tengan acceso a la tabla Prueba antes creada y puedan ceder ese derecho y el de conectarse a la base de datos a los usuarios que ellos quieran.



e)
Lidia y Jaime dejan la empresa, borra los usuarios y el espacio de tablas correspondiente, detalla los pasos necesarios para que no quede rastro del espacio de tablas.
       


## Postgres:

7. Averigua si es posible establecer cuotas de uso sobre los tablespaces en Postgres.

Postgres no posee la opción de administrar coutas, pero se puede asignar una cuota maxima de tamaño a un usuario en la partición dende se aloje el tablespace.

Pasos a seguir:  

Instalaremos el paquete **quota**, para crear e inspeccionar cuotas de disco, luego estableceremos una cuota para un usuario de ejemplo.
```shell
vagrant@postgres1:~$ sudo apt install quota
```

Nos dirigimos al fichero de fstab y lo modificamos:
```shell
vagrant@postgres1:~$ sudo nano /etc/fstab 
UUID=188b6cad-67aa-44fb-8156-1623a3d00e61 /               ext4    errors=remount-ro,usrquota,grpquota 0       1
```

Montamos una partición.
```shell
vagrant@postgres1:~$ sudo mount -o remount /
```

Podemos verificar que las nuevas opciones se usaron para montar el sistema de archivos mirando el /proc/mountsarchivo. Aquí, usamos grep para mostrar solo la entrada del sistema de archivos raíz en ese archivo:
```shell
vagrant@postgres1:~$ cat /proc/mounts | grep ' / '
/dev/sda3 / ext4 rw,relatime,quota,usrquota,grpquota,errors=remount-ro 0 0
```

Habilitamos las cuotas.
```shell
vagrant@postgres1:~$ sudo quotacheck -ugm /
```

Activamos el sistema de cuotas:
```shell
vagrant@postgres1:~$ sudo quotaon -v /
/dev/sda3 [/]: group quotas turned on
/dev/sda3 [/]: user quotas turned on
```

Ahora podremos modificar las cuotas de los usuarios.
```shell
vagrant@postgres1:~$ sudo edquota -u vagrant

  GNU nano 3.2                                      /tmp//EdP.alRTXmK                                                 

Disk quotas for user vagrant (uid 1000):
  Filesystem                   blocks       soft       hard     inodes     soft     hard
  /dev/sda3                        52          0          0         13        0        0

```

## MySQL:

8. Averigua si existe el concepto de extensión en MySQL y si coincide con el existente en ORACLE.

### Segmentos, Extensiones y Bloques e MySQL.

MySQL incorpora una característica única llamada «motores de almacenamiento», que nos permite seleccionar el tipo de almacenamiento interno de cada tabla

Los motores MyISAM e InnoDB son los más empleados, en ellos podemos encontrar extensiones, segmentos y páginas.

Ejemplo:
```shell
File system              <-> InnoDB
----------------------------------------------
disk partition           <-> tablespace
file                     <-> segment # UN FICHERO ES UN SEGMENTO.
inode                    <-> fsp0fsp.c 'inode'
fs space allocation unit <-> extent # UN ESPACIO ES UNA EXTENSIÓN.
disk block               <-> page (16 kB)# UN BLOQUE ES UNA PÁGINA.
```


### Segmentos, Extensiones y Bloques en Oracle.

Los segmentos son los equivalentes físicos de los objetos que almacenan datos. El uso efectivo de los segmentos requiere que el DBA conozca los objetos que utiliza una aplicación, cómo los datos son introducidos en esos objetos y el modo en que serán recuperados.

Como los segmentos son entidades físicas, deben estar asignados a espacios de tablas en la BD y estarán localizados en uno de los ficheros de datos del espacio de tablas. Un segmento está constituido por secciones llamadas extensiones, que son conjuntos contiguos de bloques Oracle. Una vez que una extensión existente en un segmento no puede almacenar más datos, el segmento obtendrá del espacio de tabla otra extensión. Este proceso de extensión continuará hasta que no quede más espacio disponible en los ficheros del espacio de tablas, o hasta que se alcance un número máximo de extensiónes por segmento.


## MongoDB:

9. Averigua si en MongoDB puede saberse el espacio disponible para almacenar nuevos documentos.

Mongo posee una serie de funciones para mostrar diferentes datos de almacenamiento.

Ejemplos:
```shell
#El tamaño de los datos en la colección.
db.collection.dataSize(): 
#Ver tamaño de un índice.
db.collection.index.stats().indexSizes: 
#El tamaño de los datos más el de los índices.
db.collection.totalSize():
#El tamaño de los índices.
db.collection.totalIndexSize():
```