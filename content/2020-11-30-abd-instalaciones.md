---
date: 2020-11-30
title: "Instalación y configuración de Servidores y Clientes"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - ABD
tags:
    - Servidores
    - Clientes
    - Oracle
    - MongoDB
    - MySQL
---

## ABD PRÁCTICA 2.
### Instalación de Servidores y Clientes.
#### Tipo D

Con esta práctica aprenderéis la instalación y configuración de distintos servidores y clientes de bases de datos.
Tras la instalación de cada servidor,  debe crearse una base de datos con al menos tres tablas o colecciones y poblarse de datos adecuadamente. Debe crearse un usuario y dotarlo de los privilegios necesarios para acceder remotamente a los datos.
Los clientes deben estar siempre en máquinas diferentes de los respectivos servidores a los que acceden.
Se documentará todo el proceso de configuración de los servidores.
Se aportarán pruebas del funcionamiento remoto de cada uno de los clientes.
Se aportará el código de las aplicaciones realizadas y prueba de funcionamiento de las mismas.

El trabajo constará de las siguientes partes:

* Leer bien el enunciado y comprobar que se entiende lo que se pide.

* Instalación de un servidor de ORACLE 19c sobre Linux

Nos descargamos la version zip de la web oficial de Oracle → https://www.oracle.com/es/database/technologies/oracle19c-linux-downloads.html#license-lightbox

Lo descomprimimos dentro de un directorio:
```shell
fran@debian:~$ unzip ../Descargas/LINUX.X64_193000_db_home.zip /oracle
```
Ejecutamos sun instalador:
```shell
fran@debian:~$ . runInstaller
```
![PracticaImg](images/abd/oracleinst1.png "Imagen de la practica")
![PracticaImg](images/abd/oracleinst2.png "Imagen de la practica")
![PracticaImg](images/abd/oracleinst3.png "Imagen de la practica")
![PracticaImg](images/abd/oracleinst4.png "Imagen de la practica")

* Instalación de un servidor MongoDB y configuración para permitir el acceso remoto desde la red local.

* Prueba desde un cliente remoto del intérprete de comandos de MySQL.

* Realización de una aplicación web en cualquier lenguaje que conecte con el servidor ORACLE tras autenticarse y muestre alguna información almacenada en el mismo.

* Instalación de una herramienta de administración web para MySQL y prueba desde un cliente remoto.

