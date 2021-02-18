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

* Crea un escenario que incluya una máquina y varios discos asociados a ella.
* Instala si es necesario el software de ZFS/Btrfs
* Gestiona los discos adicionales con ZFS/Btrfs
* Configura los discos en RAID, haciendo pruebas de fallo de algún disco y sustitución, restauración del RAID. Comenta ventajas e inconvenientes respecto al uso de RAID software con mdadm.
* Realiza ejercicios con pruebas de funcionamiento de las principales funcionalidades: compresión, cow, deduplicación, cifrado, etc.

<hr>

<center><img alt="zfs" src="https://magazine.odroid.com/wp-content/uploads/zfs.jpg"/></center>
ZFS es un sistema de archivos y administrador de volúmenes desarrollado originalmente por Sun Microsystems para su sistema operativo Solaris. El significado original era 'Zettabyte File System', pero ahora es un acrónimo recursivo. 

El anuncio oficial de ZFS se produjo en septiembre de 2004. El código fuente del producto final se integró en la rama principal de desarrollo de Solaris el 31 de octubre de 2005 y fue lanzado el 16 de noviembre de 2005 como parte de la compilación 27 de OpenSolaris.

ZFS fue diseñado e implementado por un equipo de Sun liderado por Jeff Bonwick.

ZFS destaca por su gran capacidad, integración de los conceptos anteriormente separados de sistema de ficheros y administrador de volúmenes en un solo producto, nueva estructura sobre el disco, sistemas de archivos ligeros y una administración de espacios de almacenamiento sencilla. 

Después de conocer un poco su historia comenzaremos a conocerlo un poco mejor como sistema de ficheros.

## Escenario
[Vagrantfile](documents/vagrantfilezfs.txt)

Crearemos un escenario en Vagrant al que le añadiremos 4 discos de 1GB.
```shell
root@buster:/home/vagrant# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0 19.8G  0 disk 
├─sda1   8:1    0 18.8G  0 part /
├─sda2   8:2    0    1K  0 part 
└─sda5   8:5    0 1021M  0 part [SWAP]
sdb      8:16   0 1000M  0 disk 
sdc      8:32   0 1000M  0 disk 
sdd      8:48   0 1000M  0 disk 
sde      8:64   0 1000M  0 disk 
```

<hr>

## Instalación de la paquetería.
Necesaría para la compilación de ZFS.
```shell
vagrant@buster:~$ sudo apt install build-essential autoconf automake libtool gawk alien fakeroot ksh zlib1g-dev uuid-dev libattr1-dev libblkid-dev libselinux-dev libudev-dev libacl1-dev libaio-dev libdevmapper-dev libssl-dev libelf-dev
vagrant@buster:~$ sudo apt-get install -y linux-headers-`uname -r` dkms
```

Descargamos ZFS del repositorio de GitHub.
```shell
wget https://github.com/zfsonlinux/zfs/releases/download/zfs-0.8.2/zfs-0.8.2.tar.gz
```

Descomprimimos y darmos permisos al directorio.
```shell
root@buster:/home/vagrant# ls
zfs-0.8.2.tar.gz
root@buster:/home/vagrant# tar axf zfs-0.8.2.tar.gz
root@buster:/home/vagrant# cd zfs-0.8.2
root@buster:/home/vagrant/zfs-0.8.2# sudo chown -R root:root ./
root@buster:/home/vagrant/zfs-0.8.2# sudo chmod -R o-rwx ./
```

Configuramos nuestra instalación de Zfs.
```shell
root@buster:/home/vagrant/zfs-0.8.2# ./configure \
> --disable-systemd \
> --enable-sysvinit \
> --disable-debug \
> --with-spec=generic \
> --with-linux=$(ls -1dtr /usr/src/linux-headers-*.*.*-common | tail -n 1) \
> --with-linux-obj=$(ls -1dtr /usr/src/linux-headers-*.*.*-amd64 | tail -n 1)
```

Compilamos.
```shell
root@buster:/home/vagrant/zfs-0.8.2# make -j1 && make install
```

Instalamos los script de inicio del servicio.
```shell
root@buster:/home/vagrant/zfs-0.8.2# cd /etc/init.d/
root@buster:/etc/init.d# ln -s /usr/local/etc/init.d/zfs-import /etc/init.d/
root@buster:/etc/init.d# ln -s /usr/local/etc/init.d/zfs-mount /etc/init.d/
root@buster:/etc/init.d# ln -s /usr/local/etc/init.d/zfs-share /etc/init.d/
root@buster:/etc/init.d# ln -s /usr/local/etc/init.d/zfs-zed /etc/init.d/
```

Habilitamos el servicio y activamos el modulo zfs.
```shell
root@buster:/etc/init.d# update-rc.d zfs-import defaults
root@buster:/etc/init.d# update-rc.d zfs-mount defaults
root@buster:/etc/init.d# update-rc.d zfs-share defaults
root@buster:/etc/init.d# update-rc.d zfs-zed defaults
root@buster:/etc/init.d# modprobe zfs
```

Comprobación
```shell
root@buster:/etc/init.d# lsmod | grep zfs
zfs                  3760128  0
zunicode              335872  1 zfs
zlua                  172032  1 zfs
zcommon                90112  1 zfs
znvpair                90112  2 zfs,zcommon
zavl                   16384  1 zfs
icp                   311296  1 zfs
spl                   114688  5 zfs,icp,znvpair,zcommon,zavl
```

## Gestiona los discos con ZFS

Configuramos los disco en RAID, haciendo pruebas de fallo de disco, sustitución y restauración del RAID.

### Creamos un pool con RAID 1.
```shell
root@buster:/etc/init.d# zpool create -f RAID1 mirror /dev/sdb /dev/sdc /dev/sdd
root@buster:/etc/init.d# sudo zpool status
  pool: RAID1
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	RAID1       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     ONLINE       0     0     0
	    sdd     ONLINE       0     0     0

errors: No known data errors
```

### Añadimos un disco de reserva.
```shell
root@buster:/etc/init.d# zpool add -f RAID1 spare /dev/sde
root@buster:/etc/init.d# sudo zpool status
  pool: RAID1
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	RAID1       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     ONLINE       0     0     0
	    sdd     ONLINE       0     0     0
	spares
	  sde       AVAIL   

errors: No known data errors
```

### Marcar un disco como fallido.
```shell
root@buster:/etc/init.d# zpool offline -f RAID1 /dev/sdd
root@buster:/etc/init.d# sudo zpool status
  pool: RAID1
 state: DEGRADED
status: One or more devices are faulted in response to persistent errors.
	Sufficient replicas exist for the pool to continue functioning in a
	degraded state.
action: Replace the faulted device, or use 'zpool clear' to mark the device
	repaired.
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	RAID1       DEGRADED     0     0     0
	  mirror-0  DEGRADED     0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     ONLINE       0     0     0
	    sdd     FAULTED      0     0     0  external device fault
	spares
	  sde       AVAIL   

errors: No known data errors
```

### Reemplazar disco fallido por el disco que tenemos en reserva.
```shell
root@buster:/etc/init.d# zpool replace -f RAID1 /dev/sdd /dev/sde
root@buster:/etc/init.d# sudo zpool status
  pool: RAID1
 state: DEGRADED
status: One or more devices are faulted in response to persistent errors.
	Sufficient replicas exist for the pool to continue functioning in a
	degraded state.
action: Replace the faulted device, or use 'zpool clear' to mark the device
	repaired.
  scan: resilvered 286K in 0 days 00:00:00 with 0 errors on Tue Feb  9 20:24:30 2021
config:

	NAME         STATE     READ WRITE CKSUM
	RAID1        DEGRADED     0     0     0
	  mirror-0   DEGRADED     0     0     0
	    sdb      ONLINE       0     0     0
	    sdc      ONLINE       0     0     0
	    spare-2  DEGRADED     0     0     0
	      sdd    FAULTED      0     0     0  external device fault
	      sde    ONLINE       0     0     0
	spares
	  sde        INUSE     currently in use

errors: No known data errors
```

### Restauración del disco fallido.
```shell
root@buster:/etc/init.d# zpool clear RAID1 /dev/sdd
root@buster:/etc/init.d# sudo zpool status
  pool: RAID1
 state: ONLINE
  scan: resilvered 286K in 0 days 00:00:00 with 0 errors on Tue Feb  9 20:24:30 2021
config:

	NAME         STATE     READ WRITE CKSUM
	RAID1        ONLINE       0     0     0
	  mirror-0   ONLINE       0     0     0
	    sdb      ONLINE       0     0     0
	    sdc      ONLINE       0     0     0
	    spare-2  ONLINE       0     0     0
	      sdd    ONLINE       0     0     0
	      sde    ONLINE       0     0     0
	spares
	  sde        INUSE     currently in use

errors: No known data errors
```

<hr>

## Funcionamiento de las principales funcionalidades.

### Compresión

Activamos el modo compresión que en su inicio esta off, activamos la compresión lz4 y comprobamos el estado de la compresión.
```shell
root@buster:/etc/init.d# zfs get compression RAID1
NAME   PROPERTY     VALUE     SOURCE
RAID1  compression  off       default
root@buster:/etc/init.d# zfs set compression=lz4 RAID1
root@buster:/etc/init.d# zfs get compression RAID1
NAME   PROPERTY     VALUE     SOURCE
RAID1  compression  lz4       local
```

Hagamos una prueba.
```shell
root@buster:/RAID1# mkdir complz4
root@buster:/RAID1# tar -cf /RAID1/complz4/prueba.tar /home/ /etc/
tar: Removing leading `/' from member names
tar: Removing leading `/' from hard link targets
root@buster:/RAID1# ls -lh /RAID1/complz4/prueba.tar 
-rw-r--r-- 1 root root 505M Feb 11 07:49 /RAID1/complz4/prueba.tar
```
Como podemos ver se ha agrupado /home y /etc en un directorio creado y se ha comprimido en .tar

### COW - Copy on Write
Su función es el ahorro de espacio y capacidad en inodos a través de un tipo de copia diferencial. La version de OpenZfs actualmente en Debian Buster no tiene esta función completamente soportada.
```shell
root@buster:/RAID1# cp --reflink=always fich1 fich2
cp: failed to clone 'fich2' from 'fich1': Operation not supported
```

### Deduplicación
Bastante parecida a COW, es una función bastante interesante a la vez que util para el almacenamiento donde se eliminan los datos redundantes de los datos almacenados.

En este caso volveremos a habilitar la deduplicación que se encuentra apagada.
```shell
root@buster:/RAID1/complz4# sudo zfs set dedup=on RAID1
```

Se realiza una copia del fichero .tar que anteriormente comprimimos.
```shell
root@buster:/RAID1/complz4# cp prueba.tar pruebadud.tar 
root@buster:/RAID1/complz4# ls -lh
total 462M
-rw-r--r-- 1 root root 505M Feb 11 07:59 pruebadud.tar
-rw-r--r-- 1 root root 505M Feb 11 07:49 prueba.tar
root@buster:/RAID1/complz4# zfs list
NAME    USED  AVAIL     REFER  MOUNTPOINT
RAID1   463M   369M      462M  /RAID1
```

Como podemos observar la suma del peso de ambos archivos no corresponde al volumen de megas usados.

### Snapshots
Un sistema de snapshots utilizado por Zfs, que nos permite recontruir imagenes anteriormente destruidas.

**Creación/Destrución**
```shell
root@buster:/RAID1# zfs create RAID1/docs -o mountpoint=/docs
root@buster:/RAID1# zfs snapshot RAID1/docs@version1
root@buster:/RAID1# zfs list -t snapshot
NAME                  USED  AVAIL     REFER  MOUNTPOINT
RAID1/docs@version1     0B      -       24K  -
root@buster:/RAID1# zfs destroy RAID1/docs@version1
root@buster:/RAID1# zfs list -t snapshot
no datasets available
```

**RollBack**
```shell
root@buster:/RAID1# echo "version 1" > /docs/data.txt
root@buster:/RAID1# cat /docs/data.txt
version 1
root@buster:/RAID1# zfs snapshot RAID1/docs@version1
root@buster:/RAID1# zfs list -t snapshot
NAME                  USED  AVAIL     REFER  MOUNTPOINT
RAID1/docs@version1     0B      -       24K  -

root@buster:/RAID1# echo "version 2" > /docs/data.txt
root@buster:/RAID1# cat /docs/data.txt
version 2
root@buster:/RAID1# zfs list -t snapshot
NAME                  USED  AVAIL     REFER  MOUNTPOINT
RAID1/docs@version1    14K      -       24K  -
root@buster:/RAID1# zfs rollback RAID1/docs@version1
root@buster:/RAID1# cat /docs/data.txt
version 1
```

<hr>

## Conclusión

En primer lugar comentar el tema de funcionalidad de este sistema de ficheros para servidores especialmente NAS donde la integridad de los archivos es uno de los aspectos más importantes, **ZFS** se diseñó desde un principio como un sistema que en la práctica será casi imposible alcanzar sus límites, con ello se logra un tiempo de vida a largo plazo, especialmente en servidores, ya que es muy costoso sustituirlos por otro nuevo, siendo necesario habitualmente hacer borrón y cuenta nueva.

Dicho esto decir que **ZFS** esta condenado a su desuso por su incompatibilidad de licencias con **CDDL** y **GPL**, lo que hace que su uso no este tan expandido y desarrollado como su rival **BTRFS** que posee un desarrollo contínuo y licencia compatible con el kernel de linux.



