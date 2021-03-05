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



2. Borra la tabla que está llenando TS2 consiguiendo que vuelvan a existir extensiones libres. Añade después otro fichero de datos a TS2.



3. Crea el tablespace TS3 gestionado localmente con un tamaño de extension uniforme de 128K y un fichero de datos asociado. Cambia la ubicación del fichero de datos y modifica la base de datos para que pueda acceder al mismo. Crea en TS3 dos tablas e inserta registros en las mismas. Comprueba que segmentos tiene TS3, qué extensiones tiene cada uno de ellos y en qué ficheros se encuentran.



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

## MySQL:

8. Averigua si existe el concepto de extensión en MySQL y si coincide con el existente en ORACLE.

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