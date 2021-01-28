---
date: 2021-01-27
title: "Sistemas de ficheros 'avanzados' ZFS/Btrfs"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - HLC
tags:
    - ZFS/Btrfs
    - Sistemas de ficheros avanzados
---

Elige uno de los dos sistemas de ficheros "avanzados".

    Crea un escenario que incluya una máquina y varios discos asociados a ella.
    Instala si es necesario el software de ZFS/Btrfs
    Gestiona los discos adicionales con ZFS/Btrfs
    Configura los discos en RAID, haciendo pruebas de fallo de algún disco y sustitución, restauración del RAID. Comenta ventajas e inconvenientes respecto al uso de RAID software con mdadm.
    Realiza ejercicios con pruebas de funcionamiento de las principales funcionalidades: compresión, cow, deduplicación, cifrado, etc.

Esta tarea se puede realizar en una instancia de OpenStack y documentarla como habitualmente o bien grabar un vídeo con una demo de las características y hacer la entrega con el enlace del vídeo.

### Preparación del escenario para la practica.
```shell
apt upgrade -y
apt install -y linux-headers-4.19.0-6-amd64
apt install -yt buster-backports dkms spl-dkms
apt install -yt buster-backports zfs-dkms zfsutils-linux
```

Para comprobar que zfs está funcionando podemos ejecutar:
```shell
systemctl status zfs-mount
```

### Creación y configuraciñon de los 'pool'.
RAIDZ 1, 2 y 3. Dependiendo del tipo tiene uno, dos o tres bit de paridad, necesitándose 3, 4 o 5 discos respectivamente.

En esta ocasión vamos a trabar con RAIDZ-2 por lo que necesitaremos 4 discos. La creación de estos pool se realiza con el comando zpool.
```shell
zpool create -f EjemploRaidZ raidz2 /dev/sdb /dev/sdc /dev/sdd /dev/sde
zpool status
```

De la misma forma que en los RAID tradicionales (como cuando los gestionamos con mdadm), podemos añadir discos de reserva (hot spare). De esta manera, si uno de los discos falla, el hot spare se reemplazaría de forma automática. Para añadir un disco en modo reserva ejecutamos:

```shell
zpool add EjemploRaidZ spare sdf
zpool status
```

### Simulación de fallos y pruebas de redundancia.
Vamos a ejecutar una serie de comandos para simular un fallo de un disco con el parámetro offline y vamos a obsevar como se reemplaza automáticamente y sin perder información.

```shell
#Creamos un arbol de directorios
mkdir -p /EjemploRaidZ/directorio/subdirectorio/
#Creamos ficheros aleatorios
dd if=/dev/urandom of=/EjemploRaidZ/ficheroRandom bs=64K count=300
dd if=/dev/urandom of=/EjemploRaidZ/directorio/ficheroRandom bs=64K count=600
echo "Prueba de un fichero" > /EjemploRaidZ/directorio/subdirectorio/fichtest
```

Antes de hacer fallar uno de los discos, vamos a generar un checksum de los dos ficheros aleatorios con el comando md5sum. De esta manera si cambia aunque sea un byte de alguno de los dos ficheros, el checksum será completamente distinto

```shell
md5sum ficheroRandom 
935a8851f013f41e0dab7afad20b7377  ficheroRandom
md5sum directorio/ficheroRandom 
49b5591a6b7daecbecd185bae9e6f769  directorio/ficheroRandom
```

Para simular el fallo del disco, vamos a ejecutar el siguiente comando.
```shell
zpool offline -f EjemploRaidZ sdc
zpool status
```

Como podemos comprobar, aunque el RAID esté degradado, gracias a que tiene una tolerancia a fallos (gracias a los 2 bits de paridad repartidos por todos los discos), seguimos obteniendo los mismos checksum por lo tanto la integridad de los ficheros está garantizada. No obstante ahora mismo nos encontramos sin redundancia, por lo que si quisiésemos acoplar el disco de reserva solo tenemos que ejecutar:
```shell
zpool replace -f EjemploRaidZ sdc sdf
zpool status
```

Ahora tenemos dos opciones; podemos indicar que hemos reparado el disco que nos ha fallado, o podemos eliminarlo del RAID y dejar funcionando el disco que antes teníamos de reserva.

### Restauración de un RAID con “rollback”.

