---
date: 2020-11-27
title: "Actualización de quijote a CentOS8"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - Sistemas
tags:
    - OpenStack
    - CentOS
    - Actualización
---



## Actualiza la instancia quijote a CentOS 8 garantizando que todos los servicios previos continúen funcionando y detalla en la tarea los aspectos más relevantes.

* En el caso de que la instancia no sea recuperable en algún punto, se tiene que volver a crear una instancia de CentOS 7 y realizar la actualización de nuevo. Lo recomendable en este caso sería crear una instantánea de volumen antes de comenzar y en el caso de tener un error irrecuperable, crear un nuevo volumen a partir de la instantánea, eliminar la instancia quijote y crear una nueva con el nuevo volumen. Una vez arrancada la nueva instancia se puede eliminar el antiguo volumen y las instantáneas asociadas.

* Nota: Aunque aparezca una advertencia de que se puede corromper el volumen al crear una instantánea cuando está en uso, se supone que LVM (el sistema sobre el que se está usando los volúmenes en este caso) soporta la creación de instantáneas en caliente (se supone ;) )


El primer paso aunque se supone que nuestra maquina es CentOS7 deberemos de comprobarlo:
```shell
[centos@quijote ~]$ cat /etc/redhat-release
CentOS Linux release 7.9.2009 (Core)
```

Comprobamos si tenemos instalado el repositorio epel-release:
```shell
[centos@quijote ~]$ yum --enablerepo=epel
Loaded plugins: fastestmirror


Error getting repository data for epel, repository not found
#en caso de no tenerlo su instalación
[centos@quijote ~]$ sudo yum install epel-release -y
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.librelabucm.org
 * extras: ftp.cixug.es
 * updates: ftp.cixug.es
base                                                               | 3.6 kB  00:00:00     
extras                                                             | 2.9 kB  00:00:00     
updates                                                            | 2.9 kB  00:00:00     
Resolving Dependencies
--> Running transaction check
---> Package epel-release.noarch 0:7-11 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

==========================================================================================
 Package                  Arch               Version             Repository          Size
==========================================================================================
Installing:
 epel-release             noarch             7-11                extras              15 k

Transaction Summary
==========================================================================================
Install  1 Package

Total download size: 15 k
Installed size: 24 k
Downloading packages:
epel-release-7-11.noarch.rpm                                       |  15 kB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : epel-release-7-11.noarch                                               1/1 
  Verifying  : epel-release-7-11.noarch                                               1/1 

Installed:
  epel-release.noarch 0:7-11                                                              

Complete!
#procederemos a descargar el gestor de paquetes yum
[centos@quijote ~]$ yum install yum-utils -y
Loaded plugins: fastestmirror
You need to be root to perform this command.
[centos@quijote ~]$ sudo yum install yum-utils -y
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
epel/x86_64/metalink                                               |  22 kB  00:00:00     
 * base: ftp.csuc.cat
 * epel: mirrors.up.pt
 * extras: ftp.csuc.cat
 * updates: ftp.csuc.cat
epel                                                               | 4.7 kB  00:00:00     
(1/3): epel/x86_64/group_gz                                        |  95 kB  00:00:00     
(2/3): epel/x86_64/updateinfo                                      | 1.0 MB  00:00:01     
(3/3): epel/x86_64/primary_db                                      | 6.9 MB  00:00:01     
Package yum-utils-1.1.31-54.el7_8.noarch already installed and latest version
Nothing to do
```

Repetiremos el mismo proceso para paquetes **rpm** que nos provee de recursos para investigar datos tales como la arquitectura, quién los provee, y la licencia.
```shell
[centos@quijote ~]$ sudo yum install rpmconf -y
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.gadix.com
 * epel: mirror.nsc.liu.se
 * extras: mirror.airenetworks.es
 * updates: mirror.airenetworks.es
Resolving Dependencies
--> Running transaction check
---> Package rpmconf.noarch 0:1.0.22-1.el7 will be installed
--> Processing Dependency: /usr/bin/python3 for package: rpmconf-1.0.22-1.el7.noarch
--> Processing Dependency: python36-rpm for package: rpmconf-1.0.22-1.el7.noarch
--> Processing Dependency: python36-rpmconf for package: rpmconf-1.0.22-1.el7.noarch
--> Processing Dependency: rpmconf-base for package: rpmconf-1.0.22-1.el7.noarch
--> Running transaction check
---> Package python3.x86_64 0:3.6.8-18.el7 will be installed
--> Processing Dependency: python3-libs(x86-64) = 3.6.8-18.el7 for package: python3-3.6.8-18.el7.x86_64
--> Processing Dependency: python3-setuptools for package: python3-3.6.8-18.el7.x86_64
--> Processing Dependency: python3-pip for package: python3-3.6.8-18.el7.x86_64
--> Processing Dependency: libpython3.6m.so.1.0()(64bit) for package: python3-3.6.8-18.el7.x86_64
---> Package python36-rpm.x86_64 0:4.11.3-8.el7 will be installed
---> Package python36-rpmconf.noarch 0:1.0.22-1.el7 will be installed
---> Package rpmconf-base.noarch 0:1.0.22-1.el7 will be installed
--> Running transaction check
---> Package python3-libs.x86_64 0:3.6.8-18.el7 will be installed
---> Package python3-pip.noarch 0:9.0.3-8.el7 will be installed
---> Package python3-setuptools.noarch 0:39.2.0-10.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

==========================================================================================
 Package                    Arch           Version                  Repository       Size
==========================================================================================
Installing:
 rpmconf                    noarch         1.0.22-1.el7             epel             23 k
Installing for dependencies:
 python3                    x86_64         3.6.8-18.el7             updates          70 k
 python3-libs               x86_64         3.6.8-18.el7             updates         6.9 M
 python3-pip                noarch         9.0.3-8.el7              base            1.6 M
 python3-setuptools         noarch         39.2.0-10.el7            base            629 k
 python36-rpm               x86_64         4.11.3-8.el7             epel            768 k
 python36-rpmconf           noarch         1.0.22-1.el7             epel             30 k
 rpmconf-base               noarch         1.0.22-1.el7             epel            6.1 k

Transaction Summary
==========================================================================================
Install  1 Package (+7 Dependent packages)

Total download size: 10 M
Installed size: 48 M
Downloading packages:
(1/8): python3-3.6.8-18.el7.x86_64.rpm                             |  70 kB  00:00:01     
warning: /var/cache/yum/x86_64/7/epel/packages/python36-rpm-4.11.3-8.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
Public key for python36-rpm-4.11.3-8.el7.x86_64.rpm is not installed
(2/8): python36-rpm-4.11.3-8.el7.x86_64.rpm                        | 768 kB  00:00:01     
(3/8): python36-rpmconf-1.0.22-1.el7.noarch.rpm                    |  30 kB  00:00:00     
(4/8): rpmconf-1.0.22-1.el7.noarch.rpm                             |  23 kB  00:00:00     
(5/8): python3-setuptools-39.2.0-10.el7.noarch.rpm                 | 629 kB  00:00:01     
(6/8): python3-libs-3.6.8-18.el7.x86_64.rpm                        | 6.9 MB  00:00:01     
(7/8): rpmconf-base-1.0.22-1.el7.noarch.rpm                        | 6.1 kB  00:00:00     
(8/8): python3-pip-9.0.3-8.el7.noarch.rpm                          | 1.6 MB  00:00:01     
------------------------------------------------------------------------------------------
Total                                                     5.5 MB/s |  10 MB  00:00:01     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
Importing GPG key 0x352C64E5:
 Userid     : "Fedora EPEL (7) <epel@fedoraproject.org>"
 Fingerprint: 91e9 7d7c 4a5e 96f1 7f3e 888f 6a2f aea2 352c 64e5
 Package    : epel-release-7-11.noarch (@extras)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : python3-setuptools-39.2.0-10.el7.noarch                                1/8 
  Installing : python3-pip-9.0.3-8.el7.noarch                                         2/8 
  Installing : python3-3.6.8-18.el7.x86_64                                            3/8 
  Installing : python3-libs-3.6.8-18.el7.x86_64                                       4/8 
  Installing : python36-rpm-4.11.3-8.el7.x86_64                                       5/8 
  Installing : python36-rpmconf-1.0.22-1.el7.noarch                                   6/8 
  Installing : rpmconf-base-1.0.22-1.el7.noarch                                       7/8 
  Installing : rpmconf-1.0.22-1.el7.noarch                                            8/8 
  Verifying  : python36-rpm-4.11.3-8.el7.x86_64                                       1/8 
  Verifying  : rpmconf-1.0.22-1.el7.noarch                                            2/8 
  Verifying  : python36-rpmconf-1.0.22-1.el7.noarch                                   3/8 
  Verifying  : python3-libs-3.6.8-18.el7.x86_64                                       4/8 
  Verifying  : python3-setuptools-39.2.0-10.el7.noarch                                5/8 
  Verifying  : rpmconf-base-1.0.22-1.el7.noarch                                       6/8 
  Verifying  : python3-3.6.8-18.el7.x86_64                                            7/8 
  Verifying  : python3-pip-9.0.3-8.el7.noarch                                         8/8 

Installed:
  rpmconf.noarch 0:1.0.22-1.el7                                                           

Dependency Installed:
  python3.x86_64 0:3.6.8-18.el7            python3-libs.x86_64 0:3.6.8-18.el7             
  python3-pip.noarch 0:9.0.3-8.el7         python3-setuptools.noarch 0:39.2.0-10.el7      
  python36-rpm.x86_64 0:4.11.3-8.el7       python36-rpmconf.noarch 0:1.0.22-1.el7         
  rpmconf-base.noarch 0:1.0.22-1.el7      

Complete!
```

Limpiamos la paqueteria:
```shell
[centos@quijote ~]$ package-cleanup --leaves
Loaded plugins: fastestmirror
libndp-1.2-9.el7.x86_64
libsysfs-2.1.0-16.el7.x86_64

[centos@quijote ~]$ package-cleanup --orphans
Loaded plugins: fastestmirror
Determining fastest mirrors
 * base: ftp.csuc.cat
 * epel: mirrors.colocall.net
 * extras: ftp.csuc.cat
 * updates: ftp.csuc.cat
kernel-3.10.0-1127.el7.x86_64
```

Instalamos el gestor de paquetes **dnf** 
```shell
[centos@quijote ~]$ sudo yum install dnf
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.csuc.cat
 * epel: mirrors.up.pt
 * extras: ftp.csuc.cat
 * updates: ftp.csuc.cat
Resolving Dependencies
--> Running transaction check
---> Package dnf.noarch 0:4.0.9.2-1.el7_6 will be installed
--> Processing Dependency: python2-dnf = 4.0.9.2-1.el7_6 for package: dnf-4.0.9.2-1.el7_6.noarch
--> Running transaction check
---> Package python2-dnf.noarch 0:4.0.9.2-1.el7_6 will be installed
--> Processing Dependency: dnf-data = 4.0.9.2-1.el7_6 for package: python2-dnf-4.0.9.2-1.el7_6.noarch
--> Processing Dependency: python2-libdnf >= 0.22.5 for package: python2-dnf-4.0.9.2-1.el7_6.noarch
--> Processing Dependency: python2-libcomps >= 0.1.8 for package: python2-dnf-4.0.9.2-1.el7_6.noarch
--> Processing Dependency: python2-hawkey >= 0.22.5 for package: python2-dnf-4.0.9.2-1.el7_6.noarch
--> Processing Dependency: libmodulemd >= 1.4.0 for package: python2-dnf-4.0.9.2-1.el7_6.noarch
--> Processing Dependency: python2-libdnf for package: python2-dnf-4.0.9.2-1.el7_6.noarch
--> Processing Dependency: python-enum34 for package: python2-dnf-4.0.9.2-1.el7_6.noarch
--> Processing Dependency: deltarpm for package: python2-dnf-4.0.9.2-1.el7_6.noarch
--> Running transaction check
---> Package deltarpm.x86_64 0:3.6-3.el7 will be installed
---> Package dnf-data.noarch 0:4.0.9.2-1.el7_6 will be installed
--> Processing Dependency: libreport-filesystem for package: dnf-data-4.0.9.2-1.el7_6.noarch
---> Package libmodulemd.x86_64 0:1.6.3-1.el7 will be installed
---> Package python-enum34.noarch 0:1.0.4-1.el7 will be installed
---> Package python2-hawkey.x86_64 0:0.22.5-2.el7_9 will be installed
--> Processing Dependency: libdnf(x86-64) = 0.22.5-2.el7_9 for package: python2-hawkey-0.22.5-2.el7_9.x86_64
--> Processing Dependency: libsolvext.so.0(SOLV_1.0)(64bit) for package: python2-hawkey-0.22.5-2.el7_9.x86_64
--> Processing Dependency: libsolv.so.0(SOLV_1.0)(64bit) for package: python2-hawkey-0.22.5-2.el7_9.x86_64
--> Processing Dependency: libsolvext.so.0()(64bit) for package: python2-hawkey-0.22.5-2.el7_9.x86_64
--> Processing Dependency: libsolv.so.0()(64bit) for package: python2-hawkey-0.22.5-2.el7_9.x86_64
--> Processing Dependency: librepo.so.0()(64bit) for package: python2-hawkey-0.22.5-2.el7_9.x86_64
--> Processing Dependency: libdnf.so.2()(64bit) for package: python2-hawkey-0.22.5-2.el7_9.x86_64
---> Package python2-libcomps.x86_64 0:0.1.8-14.el7 will be installed
--> Processing Dependency: libcomps(x86-64) = 0.1.8-14.el7 for package: python2-libcomps-0.1.8-14.el7.x86_64
--> Processing Dependency: libcomps.so.0.1.6()(64bit) for package: python2-libcomps-0.1.8-14.el7.x86_64
---> Package python2-libdnf.x86_64 0:0.22.5-2.el7_9 will be installed
--> Running transaction check
---> Package libcomps.x86_64 0:0.1.8-14.el7 will be installed
---> Package libdnf.x86_64 0:0.22.5-2.el7_9 will be installed
---> Package librepo.x86_64 0:1.8.1-8.el7_9 will be installed
---> Package libreport-filesystem.x86_64 0:2.1.11-53.el7.centos will be installed
---> Package libsolv.x86_64 0:0.6.34-4.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

==========================================================================================
 Package                    Arch         Version                      Repository     Size
==========================================================================================
Installing:
 dnf                        noarch       4.0.9.2-1.el7_6              extras        357 k
Installing for dependencies:
 deltarpm                   x86_64       3.6-3.el7                    base           82 k
 dnf-data                   noarch       4.0.9.2-1.el7_6              extras         51 k
 libcomps                   x86_64       0.1.8-14.el7                 extras         75 k
 libdnf                     x86_64       0.22.5-2.el7_9               extras        535 k
 libmodulemd                x86_64       1.6.3-1.el7                  extras        141 k
 librepo                    x86_64       1.8.1-8.el7_9                updates        82 k
 libreport-filesystem       x86_64       2.1.11-53.el7.centos         base           41 k
 libsolv                    x86_64       0.6.34-4.el7                 base          329 k
 python-enum34              noarch       1.0.4-1.el7                  base           52 k
 python2-dnf                noarch       4.0.9.2-1.el7_6              extras        414 k
 python2-hawkey             x86_64       0.22.5-2.el7_9               extras         71 k
 python2-libcomps           x86_64       0.1.8-14.el7                 extras         47 k
 python2-libdnf             x86_64       0.22.5-2.el7_9               extras        611 k

Transaction Summary
==========================================================================================
Install  1 Package (+13 Dependent packages)

Total download size: 2.8 M
Installed size: 11 M
Is this ok [y/d/N]: y
Downloading packages:
(1/14): deltarpm-3.6-3.el7.x86_64.rpm                              |  82 kB  00:00:00     
(2/14): libcomps-0.1.8-14.el7.x86_64.rpm                           |  75 kB  00:00:00     
(3/14): dnf-4.0.9.2-1.el7_6.noarch.rpm                             | 357 kB  00:00:00     
(4/14): dnf-data-4.0.9.2-1.el7_6.noarch.rpm                        |  51 kB  00:00:00     
(5/14): libmodulemd-1.6.3-1.el7.x86_64.rpm                         | 141 kB  00:00:00     
(6/14): libreport-filesystem-2.1.11-53.el7.centos.x86_64.rpm       |  41 kB  00:00:00     
(7/14): libdnf-0.22.5-2.el7_9.x86_64.rpm                           | 535 kB  00:00:00     
(8/14): python-enum34-1.0.4-1.el7.noarch.rpm                       |  52 kB  00:00:00     
(9/14): librepo-1.8.1-8.el7_9.x86_64.rpm                           |  82 kB  00:00:00     
(10/14): python2-hawkey-0.22.5-2.el7_9.x86_64.rpm                  |  71 kB  00:00:00     
(11/14): python2-libcomps-0.1.8-14.el7.x86_64.rpm                  |  47 kB  00:00:00     
(12/14): libsolv-0.6.34-4.el7.x86_64.rpm                           | 329 kB  00:00:00     
(13/14): python2-dnf-4.0.9.2-1.el7_6.noarch.rpm                    | 414 kB  00:00:00     
(14/14): python2-libdnf-0.22.5-2.el7_9.x86_64.rpm                  | 611 kB  00:00:00     
------------------------------------------------------------------------------------------
Total                                                     1.3 MB/s | 2.8 MB  00:00:02     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : libmodulemd-1.6.3-1.el7.x86_64                                        1/14 
  Installing : librepo-1.8.1-8.el7_9.x86_64                                          2/14 
  Installing : libsolv-0.6.34-4.el7.x86_64                                           3/14 
  Installing : libdnf-0.22.5-2.el7_9.x86_64                                          4/14 
  Installing : python2-libdnf-0.22.5-2.el7_9.x86_64                                  5/14 
  Installing : python2-hawkey-0.22.5-2.el7_9.x86_64                                  6/14 
  Installing : libreport-filesystem-2.1.11-53.el7.centos.x86_64                      7/14 
  Installing : dnf-data-4.0.9.2-1.el7_6.noarch                                       8/14 
  Installing : python-enum34-1.0.4-1.el7.noarch                                      9/14 
  Installing : deltarpm-3.6-3.el7.x86_64                                            10/14 
  Installing : libcomps-0.1.8-14.el7.x86_64                                         11/14 
  Installing : python2-libcomps-0.1.8-14.el7.x86_64                                 12/14 
  Installing : python2-dnf-4.0.9.2-1.el7_6.noarch                                   13/14 
  Installing : dnf-4.0.9.2-1.el7_6.noarch                                           14/14 
  Verifying  : libsolv-0.6.34-4.el7.x86_64                                           1/14 
  Verifying  : python2-libcomps-0.1.8-14.el7.x86_64                                  2/14 
  Verifying  : libcomps-0.1.8-14.el7.x86_64                                          3/14 
  Verifying  : libmodulemd-1.6.3-1.el7.x86_64                                        4/14 
  Verifying  : dnf-data-4.0.9.2-1.el7_6.noarch                                       5/14 
  Verifying  : deltarpm-3.6-3.el7.x86_64                                             6/14 
  Verifying  : python2-hawkey-0.22.5-2.el7_9.x86_64                                  7/14 
  Verifying  : librepo-1.8.1-8.el7_9.x86_64                                          8/14 
  Verifying  : libdnf-0.22.5-2.el7_9.x86_64                                          9/14 
  Verifying  : python-enum34-1.0.4-1.el7.noarch                                     10/14 
  Verifying  : python2-dnf-4.0.9.2-1.el7_6.noarch                                   11/14 
  Verifying  : dnf-4.0.9.2-1.el7_6.noarch                                           12/14 
  Verifying  : libreport-filesystem-2.1.11-53.el7.centos.x86_64                     13/14 
  Verifying  : python2-libdnf-0.22.5-2.el7_9.x86_64                                 14/14 

Installed:
  dnf.noarch 0:4.0.9.2-1.el7_6                                                            

Dependency Installed:
  deltarpm.x86_64 0:3.6-3.el7                                                             
  dnf-data.noarch 0:4.0.9.2-1.el7_6                                                       
  libcomps.x86_64 0:0.1.8-14.el7                                                          
  libdnf.x86_64 0:0.22.5-2.el7_9                                                          
  libmodulemd.x86_64 0:1.6.3-1.el7                                                        
  librepo.x86_64 0:1.8.1-8.el7_9                                                          
  libreport-filesystem.x86_64 0:2.1.11-53.el7.centos                                      
  libsolv.x86_64 0:0.6.34-4.el7                                                           
  python-enum34.noarch 0:1.0.4-1.el7                                                      
  python2-dnf.noarch 0:4.0.9.2-1.el7_6                                                    
  python2-hawkey.x86_64 0:0.22.5-2.el7_9                                                  
  python2-libcomps.x86_64 0:0.1.8-14.el7                                                  
  python2-libdnf.x86_64 0:0.22.5-2.el7_9                                                  

Complete!
```

Con estos requisitos cumplidos comenzaremos nuestra **actualización** a centos8.

```shell
[centos@quijote ~]$ sudo dnf upgrade -y
Extra Packages for Enterprise Linux 7 - x86_64            7.0 MB/s |  16 MB     00:02    
CentOS-7 - Base                                           2.5 MB/s |  10 MB     00:04    
CentOS-7 - Updates                                        1.6 MB/s | 4.0 MB     00:02    
CentOS-7 - Extras                                         549 kB/s | 283 kB     00:00    
Last metadata expiration check: 0:00:01 ago on Sat 28 Nov 2020 04:23:43 PM UTC.
Dependencies resolved.
==========================================================================================
 Package                   Arch                Version            Repository         Size
==========================================================================================
Upgrading:
 epel-release              noarch              7-13               epel               15 k

Transaction Summary
==========================================================================================
Upgrade  1 Package

Total download size: 15 k
Downloading Packages:
epel-release-7-13.noarch.rpm                               24 kB/s |  15 kB     00:00    
------------------------------------------------------------------------------------------
Total                                                      10 kB/s |  15 kB     00:01     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                  1/1 
  Upgrading        : epel-release-7-13.noarch                                         1/2 
  Cleanup          : epel-release-7-11.noarch                                         2/2 
  Verifying        : epel-release-7-13.noarch                                         1/2 
  Verifying        : epel-release-7-11.noarch                                         2/2 

Upgraded:
  epel-release-7-13.noarch                                                                

Complete!
```

Habilitamos los repositorios de centOS8:
```shell
[centos@quijote ~]$ sudo dnf install http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-repos-8.2-2.2004.0.1.el8.x86_64.rpm http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-release-8.2-2.2004.0.1.el8.x86_64.rpm http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-gpg-keys-8.2-2.2004.0.1.el8.noarch.rpm
Extra Packages for Enterprise Linux 7 - x86_64            7.3 MB/s |  16 MB     00:02    
Last metadata expiration check: 0:00:01 ago on Sat 28 Nov 2020 04:52:24 PM UTC.
centos-repos-8.2-2.2004.0.1.el8.x86_64.rpm                 62 kB/s |  13 kB     00:00    
centos-release-8.2-2.2004.0.1.el8.x86_64.rpm              118 kB/s |  21 kB     00:00    
centos-gpg-keys-8.2-2.2004.0.1.el8.noarch.rpm              71 kB/s |  12 kB     00:00    
Dependencies resolved.
==========================================================================================
 Package                Arch          Version                   Repository           Size
==========================================================================================
Installing:
 centos-repos           x86_64        8.2-2.2004.0.1.el8        @commandline         13 k
 centos-gpg-keys        noarch        8.2-2.2004.0.1.el8        @commandline         12 k
Upgrading:
 centos-release         x86_64        8.2-2.2004.0.1.el8        @commandline         21 k

Transaction Summary
==========================================================================================
Install  2 Packages
Upgrade  1 Package

Total size: 46 k
Is this ok [y/N]: y
Downloading Packages:
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                  1/1 
  Installing       : centos-gpg-keys-8.2-2.2004.0.1.el8.noarch                        1/4 
  Upgrading        : centos-release-8.2-2.2004.0.1.el8.x86_64                         2/4 
  Installing       : centos-repos-8.2-2.2004.0.1.el8.x86_64                           3/4 
  Cleanup          : centos-release-7-9.2009.0.el7.centos.x86_64                      4/4 
warning: /etc/yum/vars/infra saved as /etc/yum/vars/infra.rpmsave

  Verifying        : centos-repos-8.2-2.2004.0.1.el8.x86_64                           1/4 
  Verifying        : centos-gpg-keys-8.2-2.2004.0.1.el8.noarch                        2/4 
  Verifying        : centos-release-8.2-2.2004.0.1.el8.x86_64                         3/4 
  Verifying        : centos-release-7-9.2009.0.el7.centos.x86_64                      4/4 

Upgraded:
  centos-release-8.2-2.2004.0.1.el8.x86_64                                                

Installed:
  centos-repos-8.2-2.2004.0.1.el8.x86_64     centos-gpg-keys-8.2-2.2004.0.1.el8.noarch    

Complete!
```

Actualizamos el repositorio de **epel-release**:
```shell
[centos@quijote ~]$ sudo dnf upgrade -y epel-release
Extra Packages for Enterprise Linux 7 - x86_64            7.9 MB/s |  16 MB     00:02    
CentOS-8 - Base                                           1.8 MB/s | 2.2 MB     00:01    
CentOS-8 - AppStream                                      6.3 MB/s | 5.8 MB     00:00    
CentOS-8 - Extras                                          12 kB/s | 8.6 kB     00:00    
Last metadata expiration check: 0:00:01 ago on Sat 28 Nov 2020 04:53:43 PM UTC.
Dependencies resolved.
==========================================================================================
 Package                  Arch               Version             Repository          Size
==========================================================================================
Upgrading:
 epel-release             noarch             8-8.el8             extras              23 k

Transaction Summary
==========================================================================================
Upgrade  1 Package

Total download size: 23 k
Downloading Packages:
epel-release-8-8.el8.noarch.rpm                           244 kB/s |  23 kB     00:00    
------------------------------------------------------------------------------------------
Total                                                      95 kB/s |  23 kB     00:00     
warning: /var/cache/dnf/extras-2770d521ba03e231/packages/epel-release-8-8.el8.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID 8483c65d: NOKEY
CentOS-8 - Extras                                         0.0  B/s |   0  B     00:00    
Importing GPG key 0x8483C65D:
 Userid     : "CentOS (CentOS Official Signing Key) <security@centos.org>"
 Fingerprint: 99DB 70FA E1D7 CE22 7FB6 4882 05B5 55B3 8483 C65D
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
Key imported successfully
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                  1/1 
  Upgrading        : epel-release-8-8.el8.noarch                                      1/2 
  Cleanup          : epel-release-7-13.noarch                                         2/2 
  Verifying        : epel-release-8-8.el8.noarch                                      1/2 
  Verifying        : epel-release-7-13.noarch                                         2/2 

Upgraded:
  epel-release-8-8.el8.noarch                                                             

Complete!
```

nueva cache:
```shell
[centos@quijote ~]$ dnf makecache
Extra Packages for Enterprise Linux 8 - x86_64            5.4 MB/s | 8.4 MB     00:01    
CentOS-8 - Base                                           2.5 MB/s | 2.2 MB     00:00    
Extra Packages for Enterprise Linux Modular 8 - x86_64    126 kB/s |  98 kB     00:00    
CentOS-8 - AppStream                                      5.9 MB/s | 5.8 MB     00:00    
CentOS-8 - Extras                                          79 kB/s | 8.6 kB     00:00    
Metadata cache created.
#este comando elimina paquetes conflictivos
[centos@quijote ~]$ sudo rpm -e --nodeps sysvinit-tools
```

Actualizamos los repositorios:
```shell
[centos@quijote ~]$ sudo dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync
Extra Packages for Enterprise Linux 8 - x86_64            882 kB/s | 8.4 MB     00:09    
Extra Packages for Enterprise Linux Modular 8 - x86_64    460 kB/s |  98 kB     00:00    
Error: 
 Problem: The operation would result in removing the following protected packages: kernel 
```

Al realizar el upgrade:
```shell
[centos@quijote ~]$ sudo dnf upgrade --best --allowerasing rpm
```
Nos salian varios errores atribuibles a librerias python para solucionarlo actualizare los paquetes:
```shell
[centos@quijote ~]$ sudo rpm -e --justdb --nodeps python3-setuptools-39.2.0-10.el7.noarch
[centos@quijote ~]$ sudo rpm -e --justdb python36-rpmconf-1.0.22-1.el7.noarch rpmconf-1.0.22-1.el7.noarch
[centos@quijote ~]$ sudo rpm -e --justdb --nodeps iptables-1.4.21-35.el7.x86_64
[centos@quijote ~]$ sudo rpm -e --justdb --nodeps python3-pip-9.0.3-8.el7.noarch
[centos@quijote ~]$ sudo rpm -e --justdb --nodeps vim-minimal
```
Ahora nos da error por el paquete yum ya que estoy usando rpm no sera necesario conservarlo lo eliminaremos:

```shell
[centos@quijote ~]$ sudo dnf -y remove yum yum-metadata-parser
Dependencies resolved.
=======================================================================================================================================================================
 Package                                          Arch                           Version                                         Repository                       Size
=======================================================================================================================================================================
Removing:
 yum                                              noarch                         3.4.3-168.el7.centos                            @System                         5.6 M
 yum-metadata-parser                              x86_64                         1.1.4-10.el7                                    @System                          57 k
Removing dependent packages:
 yum-plugin-fastestmirror                         noarch                         1.1.31-54.el7_8                                 @System                          53 k
 yum-utils                                        noarch                         1.1.31-54.el7_8                                 @System                         337 k

Transaction Summary
=======================================================================================================================================================================
Remove  4 Packages

Freed space: 6.0 M
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                               1/1 
  Erasing          : yum-utils-1.1.31-54.el7_8.noarch                                                                                                              1/4 
  Erasing          : yum-plugin-fastestmirror-1.1.31-54.el7_8.noarch                                                                                               2/4 
  Erasing          : yum-3.4.3-168.el7.centos.noarch                                                                                                               3/4 
  Erasing          : yum-metadata-parser-1.1.4-10.el7.x86_64                                                                                                       4/4 
  Verifying        : yum-3.4.3-168.el7.centos.noarch                                                                                                               1/4 
  Verifying        : yum-metadata-parser-1.1.4-10.el7.x86_64                                                                                                       2/4 
  Verifying        : yum-plugin-fastestmirror-1.1.31-54.el7_8.noarch                                                                                               3/4 
  Verifying        : yum-utils-1.1.31-54.el7_8.noarch                                                                                                              4/4 

Removed:
  yum-3.4.3-168.el7.centos.noarch    yum-metadata-parser-1.1.4-10.el7.x86_64    yum-plugin-fastestmirror-1.1.31-54.el7_8.noarch    yum-utils-1.1.31-54.el7_8.noarch   

Complete!
[centos@quijote ~]$ sudo rm -Rf /etc/yum
```

Ahora si podremos realizar el upgrade satistactoriamente:
```shell
[centos@quijote ~]$ sudo dnf upgrade --best --allowerasing rpm
Last metadata expiration check: 0:03:18 ago on Sat 28 Nov 2020 05:13:36 PM UTC.
Dependencies resolved.
=======================================================================================================================================================================
 Package                                       Arch                      Version                                                    Repository                    Size
=======================================================================================================================================================================
Upgrading:
 bc                                            x86_64                    1.07.1-5.el8                                               BaseOS                       129 k
 bind-export-libs                              x86_64                    32:9.11.13-6.el8_2.1                                       BaseOS                       1.1 M
 binutils                                      x86_64                    2.30-73.el8                                                BaseOS                       5.7 M
 cryptsetup-libs                               x86_64                    2.2.2-1.el8                                                BaseOS                       428 k
 dhcp-common                                   noarch                    12:4.3.6-40.el8                                            BaseOS                       207 k
 dhcp-libs                                     x86_64                    12:4.3.6-40.el8                                            BaseOS                       147 k
 dnf                                           noarch                    4.2.17-7.el8_2                                             BaseOS                       469 k
 dnf-data                                      noarch                    4.2.17-7.el8_2                                             BaseOS                       145 k
 gdbm                                          x86_64                    1:1.18-1.el8                                               BaseOS                       130 k
 gettext                                       x86_64                    0.19.8.1-17.el8                                            BaseOS                       1.1 M
 gettext-libs                                  x86_64                    0.19.8.1-17.el8                                            BaseOS                       314 k
 glibc                                         x86_64                    2.28-101.el8                                               BaseOS                       3.7 M
 glibc-common                                  x86_64                    2.28-101.el8                                               BaseOS                       1.3 M
 gnupg2                                        x86_64                    2.2.9-1.el8                                                BaseOS                       2.3 M
 gpgme                                         x86_64                    1.10.0-6.el8.0.1                                           BaseOS                       241 k
 grep                                          x86_64                    3.1-6.el8                                                  BaseOS                       274 k
 initscripts                                   x86_64                    10.00.6-1.el8_2.2                                          BaseOS                       338 k
 json-c                                        x86_64                    0.13.1-0.2.el8                                             BaseOS                        40 k
 libblkid                                      x86_64                    2.32.1-22.el8                                              BaseOS                       214 k
 libcomps                                      x86_64                    0.1.11-4.el8                                               BaseOS                        81 k
 libdnf                                        x86_64                    0.39.1-6.el8_2                                             BaseOS                       620 k
     replacing  python2-hawkey.x86_64 0.22.5-2.el7_9
     replacing  python2-libdnf.x86_64 0.22.5-2.el7_9
 libevent                                      x86_64                    2.1.8-5.el8                                                BaseOS                       253 k
 libgcrypt                                     x86_64                    1.8.3-4.el8                                                BaseOS                       461 k
 libgpg-error                                  x86_64                    1.31-1.el8                                                 BaseOS                       242 k
 libmount                                      x86_64                    2.32.1-22.el8                                              BaseOS                       231 k
 libnfsidmap                                   x86_64                    1:2.3.3-31.el8                                             BaseOS                       118 k
 librepo                                       x86_64                    1.11.0-3.el8_2                                             BaseOS                        90 k
 libsmartcols                                  x86_64                    2.32.1-22.el8                                              BaseOS                       174 k
 libsolv                                       x86_64                    0.7.7-1.el8                                                BaseOS                       356 k
 libstdc++                                     x86_64                    8.3.1-5.el8.0.2                                            BaseOS                       451 k
 libtirpc                                      x86_64                    1.1.4-4.el8                                                BaseOS                       113 k
 libunistring                                  x86_64                    0.9.9-3.el8                                                BaseOS                       422 k
 libuuid                                       x86_64                    2.32.1-22.el8                                              BaseOS                        94 k
 libverto                                      x86_64                    0.3.0-5.el8                                                BaseOS                        24 k
 libverto-libevent                             x86_64                    0.3.0-5.el8                                                BaseOS                        16 k
 man-db                                        x86_64                    2.7.6.1-17.el8                                             BaseOS                       887 k
 ncurses                                       x86_64                    6.1-7.20180224.el8                                         BaseOS                       387 k
 ncurses-base                                  noarch                    6.1-7.20180224.el8                                         BaseOS                        81 k
 ncurses-libs                                  x86_64                    6.1-7.20180224.el8                                         BaseOS                       335 k
 nfs-utils                                     x86_64                    1:2.3.3-31.el8                                             BaseOS                       468 k
 openssh                                       x86_64                    8.0p1-4.el8_1                                              BaseOS                       496 k
 openssh-clients                               x86_64                    8.0p1-4.el8_1                                              BaseOS                       704 k
 openssh-server                                x86_64                    8.0p1-4.el8_1                                              BaseOS                       485 k
 openssl                                       x86_64                    1:1.1.1c-15.el8                                            BaseOS                       697 k
 openssl-libs                                  x86_64                    1:1.1.1c-15.el8                                            BaseOS                       1.5 M
 parted                                        x86_64                    3.2-38.el8                                                 BaseOS                       557 k
 python3-libs                                  x86_64                    3.6.8-23.el8                                               BaseOS                       7.8 M
 readline                                      x86_64                    7.0-10.el8                                                 BaseOS                       199 k
 rpcbind                                       x86_64                    1.2.5-7.el8                                                BaseOS                        70 k
 rpm                                           x86_64                    4.14.2-37.el8                                              BaseOS                       540 k
 rpm-build-libs                                x86_64                    4.14.2-37.el8                                              BaseOS                       154 k
 rpm-libs                                      x86_64                    4.14.2-37.el8                                              BaseOS                       337 k
 sqlite                                        x86_64                    3.26.0-6.el8                                               BaseOS                       666 k
 sudo                                          x86_64                    1.8.29-5.el8                                               BaseOS                       923 k
 systemd                                       x86_64                    239-31.el8_2.2                                             BaseOS                       3.5 M
 systemd-libs                                  x86_64                    239-31.el8_2.2                                             BaseOS                       1.1 M
 tuned                                         noarch                    2.13.0-6.el8                                               BaseOS                       281 k
 util-linux                                    x86_64                    2.32.1-22.el8                                              BaseOS                       2.5 M
 which                                         x86_64                    2.21-12.el8                                                BaseOS                        49 k
 xfsprogs                                      x86_64                    5.0.0-2.el8                                                BaseOS                       1.1 M
 xz                                            x86_64                    5.2.4-3.el8                                                BaseOS                       153 k
 xz-libs                                       x86_64                    5.2.4-3.el8                                                BaseOS                        94 k
 lua                                           x86_64                    5.3.4-11.el8                                               AppStream                    193 k
Installing dependencies:
 authselect                                    x86_64                    1.1-2.el8                                                  BaseOS                        65 k
 authselect-libs                               x86_64                    1.1-2.el8                                                  BaseOS                       187 k
 centos-obsolete-packages                      noarch                    8-4                                                        BaseOS                       8.5 k
 crypto-policies                               noarch                    20191128-2.git23e1bf1.el8                                  BaseOS                       103 k
 dhcp-client                                   x86_64                    12:4.3.6-40.el8                                            BaseOS                       318 k
     replacing  dhclient.x86_64 12:4.2.5-82.el7.centos
 gdbm-libs                                     x86_64                    1:1.18-1.el8                                               BaseOS                        60 k
 glibc-all-langpacks                           x86_64                    2.28-101.el8                                               BaseOS                        25 M
 gnutls                                        x86_64                    3.6.8-11.el8_2                                             BaseOS                       915 k
 hdparm                                        x86_64                    9.54-2.el8                                                 BaseOS                       100 k
 ima-evm-utils                                 x86_64                    1.1-5.el8                                                  BaseOS                        56 k
 ipcalc                                        x86_64                    0.2.4-4.el8                                                BaseOS                        38 k
 iptables-libs                                 x86_64                    1.8.4-10.el8_2.1                                           BaseOS                       105 k
 libarchive                                    x86_64                    3.3.2-8.el8_1                                              BaseOS                       359 k
 libfdisk                                      x86_64                    2.32.1-22.el8                                              BaseOS                       249 k
 libidn2                                       x86_64                    2.2.0-1.el8                                                BaseOS                        94 k
 libksba                                       x86_64                    1.3.5-7.el8                                                BaseOS                       135 k
 libnsl                                        x86_64                    2.28-101.el8                                               BaseOS                        97 k
 libnsl2                                       x86_64                    1.2.0-2.20180605git4a062cf.el8                             BaseOS                        58 k
 libpcap                                       x86_64                    14:1.9.0-3.el8                                             BaseOS                       160 k
 libusbx                                       x86_64                    1.0.22-1.el8                                               BaseOS                        71 k
 libxcrypt                                     x86_64                    4.1.1-4.el8                                                BaseOS                        73 k
 libzstd                                       x86_64                    1.4.2-2.el8                                                BaseOS                       260 k
 lua-libs                                      x86_64                    5.3.4-11.el8                                               BaseOS                       118 k
 ncurses-compat-libs                           x86_64                    6.1-7.20180224.el8                                         BaseOS                       331 k
 netconsole-service                            noarch                    10.00.6-1.el8_2.2                                          BaseOS                       148 k
 nettle                                        x86_64                    3.4.1-1.el8                                                BaseOS                       302 k
 network-scripts                               x86_64                    10.00.6-1.el8_2.2                                          BaseOS                       195 k
 npth                                          x86_64                    1.5-4.el8                                                  BaseOS                        26 k
 pcre2                                         x86_64                    10.32-1.el8                                                BaseOS                       244 k
 platform-python                               x86_64                    3.6.8-23.el8                                               BaseOS                        82 k
 platform-python-setuptools                    noarch                    39.2.0-5.el8                                               BaseOS                       632 k
 psmisc                                        x86_64                    23.1-4.el8                                                 BaseOS                       150 k
 python3-configobj                             noarch                    5.0.6-11.el8                                               BaseOS                        68 k
 python3-dbus                                  x86_64                    1.2.4-15.el8                                               BaseOS                       134 k
 python3-decorator                             noarch                    4.2.1-2.el8                                                BaseOS                        27 k
 python3-dnf                                   noarch                    4.2.17-7.el8_2                                             BaseOS                       521 k
 python3-gobject-base                          x86_64                    3.28.3-1.el8                                               BaseOS                       313 k
 python3-gpg                                   x86_64                    1.10.0-6.el8.0.1                                           BaseOS                       229 k
 python3-hawkey                                x86_64                    0.39.1-6.el8_2                                             BaseOS                        99 k
 python3-libcomps                              x86_64                    0.1.11-4.el8                                               BaseOS                        52 k
 python3-libdnf                                x86_64                    0.39.1-6.el8_2                                             BaseOS                       689 k
 python3-linux-procfs                          noarch                    0.6-7.el8                                                  BaseOS                        42 k
 python3-perf                                  x86_64                    4.18.0-193.28.1.el8_2                                      BaseOS                       2.9 M
 python3-pip-wheel                             noarch                    9.0.3-16.el8                                               BaseOS                       1.2 M
 python3-pyudev                                noarch                    0.21.0-7.el8                                               BaseOS                        84 k
 python3-rpm                                   x86_64                    4.14.2-37.el8                                              BaseOS                       156 k
 python3-schedutils                            x86_64                    0.6-6.el8                                                  BaseOS                        29 k
 python3-setuptools-wheel                      noarch                    39.2.0-5.el8                                               BaseOS                       289 k
 python3-six                                   noarch                    1.11.0-8.el8                                               BaseOS                        38 k
 python3-syspurpose                            x86_64                    1.26.20-1.el8_2                                            BaseOS                       287 k
 readonly-root                                 noarch                    10.00.6-1.el8_2.2                                          BaseOS                       150 k
 sqlite-libs                                   x86_64                    3.26.0-6.el8                                               BaseOS                       579 k
 systemd-container                             x86_64                    239-31.el8_2.2                                             BaseOS                       725 k
 systemd-pam                                   x86_64                    239-31.el8_2.2                                             BaseOS                       451 k
 systemd-udev                                  x86_64                    239-31.el8_2.2                                             BaseOS                       1.3 M
 trousers-lib                                  x86_64                    0.3.14-4.el8                                               BaseOS                       169 k
 vim-minimal                                   x86_64                    2:8.0.1763-13.el8                                          BaseOS                       573 k
 authselect-compat                             x86_64                    1.1-2.el8                                                  AppStream                     37 k
     replacing  authconfig.x86_64 6.2.8-30.el7
 compat-openssl10                              x86_64                    1:1.0.2o-3.el8                                             AppStream                    1.1 M
 oddjob                                        x86_64                    0.34.4-7.el8                                               AppStream                     83 k
 python2                                       x86_64                    2.7.17-1.module_el8.2.0+381+9a5b3c3b                       AppStream                    108 k
 python2-libs                                  x86_64                    2.7.17-1.module_el8.2.0+381+9a5b3c3b                       AppStream                    6.0 M
 python2-pip-wheel                             noarch                    9.0.3-16.module_el8.2.0+381+9a5b3c3b                       AppStream                    1.2 M
 python2-setuptools-wheel                      noarch                    39.0.1-11.module_el8.2.0+381+9a5b3c3b                      AppStream                    289 k
 unbound-libs                                  x86_64                    1.7.3-11.el8_2                                             AppStream                    499 k
 xkeyboard-config                              noarch                    2.28-1.el8                                                 AppStream                    782 k
Installing weak dependencies:
 gnupg2-smime                                  x86_64                    2.2.9-1.el8                                                BaseOS                       279 k
 network-scripts-team                          x86_64                    1.29-1.el8_2.2                                             BaseOS                        27 k
 openssl-pkcs11                                x86_64                    0.4.10-2.el8                                               BaseOS                        66 k
 platform-python-pip                           noarch                    9.0.3-16.el8                                               BaseOS                       1.8 M
 rpm-plugin-systemd-inhibit                    x86_64                    4.14.2-37.el8                                              BaseOS                        76 k
 trousers                                      x86_64                    0.3.14-4.el8                                               BaseOS                       153 k
 geolite2-city                                 noarch                    20180605-1.el8                                             AppStream                     19 M
 geolite2-country                              noarch                    20180605-1.el8                                             AppStream                    1.0 M
 libmaxminddb                                  x86_64                    1.2.0-7.el8                                                AppStream                     25 k
 libxkbcommon                                  x86_64                    0.9.1-1.el8                                                AppStream                    116 k
 oddjob-mkhomedir                              x86_64                    0.34.4-7.el8                                               AppStream                     52 k
 python2-pip                                   noarch                    9.0.3-16.module_el8.2.0+381+9a5b3c3b                       AppStream                    1.9 M
 python2-setuptools                            noarch                    39.0.1-11.module_el8.2.0+381+9a5b3c3b                      AppStream                    643 k
 python3-unbound                               x86_64                    1.7.3-11.el8_2                                             AppStream                    118 k
Removing dependent packages:
 cloud-init                                    x86_64                    19.4-7.el7.centos.2                                        @System                      3.2 M
 deltarpm                                      x86_64                    3.6-3.el7                                                  @System                      209 k
 grub2                                         x86_64                    1:2.02-0.86.el7.centos                                     @System                        0  
 grub2-pc                                      x86_64                    1:2.02-0.86.el7.centos                                     @System                        0  
 grub2-tools                                   x86_64                    1:2.02-0.86.el7.centos                                     @System                      9.7 M
 grub2-tools-extra                             x86_64                    1:2.02-0.86.el7.centos                                     @System                      6.1 M
 libsemanage-python                            x86_64                    2.5-14.el7                                                 @System                      441 k
 libxml2-python                                x86_64                    2.9.1-6.el7.5                                              @System                      1.4 M
 policycoreutils-python                        x86_64                    2.5-34.el7                                                 @System                      1.2 M
 pyserial                                      noarch                    2.6-6.el7                                                  @System                      538 k
 python                                        x86_64                    2.7.5-90.el7                                               @System                       79 k
 python-chardet                                noarch                    2.2.1-3.el7                                                @System                      1.1 M
 python-jsonpatch                              noarch                    1.2-4.el7                                                  @System                       52 k
 python-jsonpointer                            noarch                    1.9-2.el7                                                  @System                       34 k
 python-kitchen                                noarch                    1.1.1-5.el7                                                @System                      1.4 M
 python-libs                                   x86_64                    2.7.5-90.el7                                               @System                       24 M
 python-linux-procfs                           noarch                    0.4.11-4.el7                                               @System                       95 k
 python-requests                               noarch                    2.6.0-10.el7                                               @System                      341 k
 python-schedutils                             x86_64                    0.4-6.el7                                                  @System                       42 k
 python-setuptools                             noarch                    0.9.8-7.el7                                                @System                      1.9 M
 python-urlgrabber                             noarch                    3.10-10.el7                                                @System                      492 k
 python2-dnf                                   noarch                    4.0.9.2-1.el7_6                                            @System                      1.9 M
 python2-libcomps                              x86_64                    0.1.8-14.el7                                               @System                      140 k
 python3                                       x86_64                    3.6.8-18.el7                                               @System                       39 k
 python36-rpm                                  x86_64                    4.11.3-8.el7                                               @System                      905 k
 pyxattr                                       x86_64                    0.5.1-5.el7                                                @System                       62 k
 rpm-python                                    x86_64                    4.11.3-45.el7                                              @System                      146 k
 systemd-sysv                                  x86_64                    219-78.el7_9.2                                             @System                      3.9 k

Transaction Summary
=======================================================================================================================================================================
Install  80 Packages
Upgrade  63 Packages
Remove   28 Packages

Total download size: 125 M
Is this ok [y/N]: y
Downloading Packages:
(1/143): authselect-libs-1.1-2.el8.x86_64.rpm                                                                                          1.4 MB/s | 187 kB     00:00    
(2/143): crypto-policies-20191128-2.git23e1bf1.el8.noarch.rpm                                                                          5.8 MB/s | 103 kB     00:00    
(3/143): authselect-1.1-2.el8.x86_64.rpm                                                                                               348 kB/s |  65 kB     00:00    
(4/143): dhcp-client-4.3.6-40.el8.x86_64.rpm                                                                                           7.2 MB/s | 318 kB     00:00    
(5/143): centos-obsolete-packages-8-4.noarch.rpm                                                                                        43 kB/s | 8.5 kB     00:00    
(6/143): gdbm-libs-1.18-1.el8.x86_64.rpm                                                                                               3.3 MB/s |  60 kB     00:00    
(7/143): gnupg2-smime-2.2.9-1.el8.x86_64.rpm                                                                                           1.2 MB/s | 279 kB     00:00    
(8/143): hdparm-9.54-2.el8.x86_64.rpm                                                                                                  2.0 MB/s | 100 kB     00:00    
(9/143): ima-evm-utils-1.1-5.el8.x86_64.rpm                                                                                            1.1 MB/s |  56 kB     00:00    
(10/143): ipcalc-0.2.4-4.el8.x86_64.rpm                                                                                                773 kB/s |  38 kB     00:00    
(11/143): iptables-libs-1.8.4-10.el8_2.1.x86_64.rpm                                                                                    2.2 MB/s | 105 kB     00:00    
(12/143): libarchive-3.3.2-8.el8_1.x86_64.rpm                                                                                          6.9 MB/s | 359 kB     00:00    
(13/143): libfdisk-2.32.1-22.el8.x86_64.rpm                                                                                            5.1 MB/s | 249 kB     00:00    
(14/143): libidn2-2.2.0-1.el8.x86_64.rpm                                                                                               2.2 MB/s |  94 kB     00:00    
(15/143): libksba-1.3.5-7.el8.x86_64.rpm                                                                                               2.3 MB/s | 135 kB     00:00    
(16/143): gnutls-3.6.8-11.el8_2.x86_64.rpm                                                                                             1.4 MB/s | 915 kB     00:00    
(17/143): libnsl-2.28-101.el8.x86_64.rpm                                                                                               2.1 MB/s |  97 kB     00:00    
(18/143): libnsl2-1.2.0-2.20180605git4a062cf.el8.x86_64.rpm                                                                            1.9 MB/s |  58 kB     00:00    
(19/143): libpcap-1.9.0-3.el8.x86_64.rpm                                                                                               2.6 MB/s | 160 kB     00:00    
(20/143): libusbx-1.0.22-1.el8.x86_64.rpm                                                                                              1.8 MB/s |  71 kB     00:00    
(21/143): libxcrypt-4.1.1-4.el8.x86_64.rpm                                                                                             2.0 MB/s |  73 kB     00:00    
(22/143): libzstd-1.4.2-2.el8.x86_64.rpm                                                                                               2.6 MB/s | 260 kB     00:00    
(23/143): lua-libs-5.3.4-11.el8.x86_64.rpm                                                                                             1.8 MB/s | 118 kB     00:00    
(24/143): netconsole-service-10.00.6-1.el8_2.2.noarch.rpm                                                                              2.0 MB/s | 148 kB     00:00    
(25/143): ncurses-compat-libs-6.1-7.20180224.el8.x86_64.rpm                                                                            2.6 MB/s | 331 kB     00:00    
(26/143): nettle-3.4.1-1.el8.x86_64.rpm                                                                                                2.2 MB/s | 302 kB     00:00    
(27/143): network-scripts-10.00.6-1.el8_2.2.x86_64.rpm                                                                                 1.9 MB/s | 195 kB     00:00    
(28/143): network-scripts-team-1.29-1.el8_2.2.x86_64.rpm                                                                               1.0 MB/s |  27 kB     00:00    
(29/143): npth-1.5-4.el8.x86_64.rpm                                                                                                    1.0 MB/s |  26 kB     00:00    
(30/143): openssl-pkcs11-0.4.10-2.el8.x86_64.rpm                                                                                       1.5 MB/s |  66 kB     00:00    
(31/143): platform-python-3.6.8-23.el8.x86_64.rpm                                                                                      1.3 MB/s |  82 kB     00:00    
(32/143): pcre2-10.32-1.el8.x86_64.rpm                                                                                                 2.2 MB/s | 244 kB     00:00    
(33/143): platform-python-pip-9.0.3-16.el8.noarch.rpm                                                                                  2.7 MB/s | 1.8 MB     00:00    
(34/143): platform-python-setuptools-39.2.0-5.el8.noarch.rpm                                                                           955 kB/s | 632 kB     00:00    
(35/143): python3-configobj-5.0.6-11.el8.noarch.rpm                                                                                    967 kB/s |  68 kB     00:00    
(36/143): psmisc-23.1-4.el8.x86_64.rpm                                                                                                 1.5 MB/s | 150 kB     00:00    
(37/143): python3-decorator-4.2.1-2.el8.noarch.rpm                                                                                     644 kB/s |  27 kB     00:00    
(38/143): python3-dbus-1.2.4-15.el8.x86_64.rpm                                                                                         1.4 MB/s | 134 kB     00:00    
(39/143): python3-gobject-base-3.28.3-1.el8.x86_64.rpm                                                                                 1.8 MB/s | 313 kB     00:00    
(40/143): python3-dnf-4.2.17-7.el8_2.noarch.rpm                                                                                        1.3 MB/s | 521 kB     00:00    
(41/143): python3-gpg-1.10.0-6.el8.0.1.x86_64.rpm                                                                                      1.2 MB/s | 229 kB     00:00    
(42/143): python3-libcomps-0.1.11-4.el8.x86_64.rpm                                                                                     823 kB/s |  52 kB     00:00    
(43/143): python3-hawkey-0.39.1-6.el8_2.x86_64.rpm                                                                                     1.0 MB/s |  99 kB     00:00    
(44/143): python3-linux-procfs-0.6-7.el8.noarch.rpm                                                                                    741 kB/s |  42 kB     00:00    
(45/143): python3-libdnf-0.39.1-6.el8_2.x86_64.rpm                                                                                     1.4 MB/s | 689 kB     00:00    
(46/143): python3-perf-4.18.0-193.28.1.el8_2.x86_64.rpm                                                                                2.5 MB/s | 2.9 MB     00:01    
(47/143): python3-pip-wheel-9.0.3-16.el8.noarch.rpm                                                                                    1.4 MB/s | 1.2 MB     00:00    
(48/143): python3-pyudev-0.21.0-7.el8.noarch.rpm                                                                                       815 kB/s |  84 kB     00:00    
(49/143): python3-schedutils-0.6-6.el8.x86_64.rpm                                                                                      511 kB/s |  29 kB     00:00    
(50/143): python3-rpm-4.14.2-37.el8.x86_64.rpm                                                                                         1.5 MB/s | 156 kB     00:00    
(51/143): glibc-all-langpacks-2.28-101.el8.x86_64.rpm                                                                                  6.2 MB/s |  25 MB     00:04    
(52/143): python3-six-1.11.0-8.el8.noarch.rpm                                                                                          196 kB/s |  38 kB     00:00    
(53/143): python3-setuptools-wheel-39.2.0-5.el8.noarch.rpm                                                                             1.2 MB/s | 289 kB     00:00    
(54/143): rpm-plugin-systemd-inhibit-4.14.2-37.el8.x86_64.rpm                                                                          3.2 MB/s |  76 kB     00:00    
(55/143): readonly-root-10.00.6-1.el8_2.2.noarch.rpm                                                                                   3.3 MB/s | 150 kB     00:00    
(56/143): python3-syspurpose-1.26.20-1.el8_2.x86_64.rpm                                                                                1.9 MB/s | 287 kB     00:00    
(57/143): systemd-pam-239-31.el8_2.2.x86_64.rpm                                                                                        5.6 MB/s | 451 kB     00:00    
(58/143): sqlite-libs-3.26.0-6.el8.x86_64.rpm                                                                                          2.5 MB/s | 579 kB     00:00    
(59/143): trousers-0.3.14-4.el8.x86_64.rpm                                                                                             4.6 MB/s | 153 kB     00:00    
(60/143): trousers-lib-0.3.14-4.el8.x86_64.rpm                                                                                         3.6 MB/s | 169 kB     00:00    
(61/143): systemd-container-239-31.el8_2.2.x86_64.rpm                                                                                  2.0 MB/s | 725 kB     00:00    
(62/143): authselect-compat-1.1-2.el8.x86_64.rpm                                                                                       855 kB/s |  37 kB     00:00    
(63/143): vim-minimal-8.0.1763-13.el8.x86_64.rpm                                                                                       2.8 MB/s | 573 kB     00:00    
(64/143): systemd-udev-239-31.el8_2.2.x86_64.rpm                                                                                       3.2 MB/s | 1.3 MB     00:00    
(65/143): compat-openssl10-1.0.2o-3.el8.x86_64.rpm                                                                                     3.5 MB/s | 1.1 MB     00:00    
(66/143): libmaxminddb-1.2.0-7.el8.x86_64.rpm                                                                                          1.2 MB/s |  25 kB     00:00    
(67/143): libxkbcommon-0.9.1-1.el8.x86_64.rpm                                                                                          2.2 MB/s | 116 kB     00:00    
(68/143): oddjob-0.34.4-7.el8.x86_64.rpm                                                                                               1.5 MB/s |  83 kB     00:00    
(69/143): oddjob-mkhomedir-0.34.4-7.el8.x86_64.rpm                                                                                     1.1 MB/s |  52 kB     00:00    
(70/143): python2-2.7.17-1.module_el8.2.0+381+9a5b3c3b.x86_64.rpm                                                                      1.6 MB/s | 108 kB     00:00    
(71/143): geolite2-country-20180605-1.el8.noarch.rpm                                                                                   2.5 MB/s | 1.0 MB     00:00    
(72/143): python2-pip-9.0.3-16.module_el8.2.0+381+9a5b3c3b.noarch.rpm                                                                  1.7 MB/s | 1.9 MB     00:01    
(73/143): python2-libs-2.7.17-1.module_el8.2.0+381+9a5b3c3b.x86_64.rpm                                                                 4.6 MB/s | 6.0 MB     00:01    
(74/143): python2-setuptools-39.0.1-11.module_el8.2.0+381+9a5b3c3b.noarch.rpm                                                          1.7 MB/s | 643 kB     00:00    
(75/143): python2-pip-wheel-9.0.3-16.module_el8.2.0+381+9a5b3c3b.noarch.rpm                                                            2.2 MB/s | 1.2 MB     00:00    
(76/143): python2-setuptools-wheel-39.0.1-11.module_el8.2.0+381+9a5b3c3b.noarch.rpm                                                    2.1 MB/s | 289 kB     00:00    
(77/143): python3-unbound-1.7.3-11.el8_2.x86_64.rpm                                                                                    1.2 MB/s | 118 kB     00:00    
(78/143): unbound-libs-1.7.3-11.el8_2.x86_64.rpm                                                                                       2.7 MB/s | 499 kB     00:00    
(79/143): bc-1.07.1-5.el8.x86_64.rpm                                                                                                   1.2 MB/s | 129 kB     00:00    
(80/143): xkeyboard-config-2.28-1.el8.noarch.rpm                                                                                       1.9 MB/s | 782 kB     00:00    
(81/143): bind-export-libs-9.11.13-6.el8_2.1.x86_64.rpm                                                                                2.2 MB/s | 1.1 MB     00:00    
(82/143): cryptsetup-libs-2.2.2-1.el8.x86_64.rpm                                                                                       1.6 MB/s | 428 kB     00:00    
(83/143): geolite2-city-20180605-1.el8.noarch.rpm                                                                                      5.3 MB/s |  19 MB     00:03    
(84/143): dhcp-common-4.3.6-40.el8.noarch.rpm                                                                                          809 kB/s | 207 kB     00:00    
(85/143): dhcp-libs-4.3.6-40.el8.x86_64.rpm                                                                                            1.5 MB/s | 147 kB     00:00    
(86/143): dnf-data-4.2.17-7.el8_2.noarch.rpm                                                                                           1.0 MB/s | 145 kB     00:00    
(87/143): dnf-4.2.17-7.el8_2.noarch.rpm                                                                                                1.9 MB/s | 469 kB     00:00    
(88/143): gdbm-1.18-1.el8.x86_64.rpm                                                                                                   1.1 MB/s | 130 kB     00:00    
(89/143): binutils-2.30-73.el8.x86_64.rpm                                                                                              4.3 MB/s | 5.7 MB     00:01    
(90/143): gettext-0.19.8.1-17.el8.x86_64.rpm                                                                                           4.0 MB/s | 1.1 MB     00:00    
(91/143): gettext-libs-0.19.8.1-17.el8.x86_64.rpm                                                                                      914 kB/s | 314 kB     00:00    
(92/143): glibc-common-2.28-101.el8.x86_64.rpm                                                                                         3.5 MB/s | 1.3 MB     00:00    
(93/143): gpgme-1.10.0-6.el8.0.1.x86_64.rpm                                                                                            1.7 MB/s | 241 kB     00:00    
(94/143): grep-3.1-6.el8.x86_64.rpm                                                                                                    1.4 MB/s | 274 kB     00:00    
(95/143): glibc-2.28-101.el8.x86_64.rpm                                                                                                4.0 MB/s | 3.7 MB     00:00    
(96/143): json-c-0.13.1-0.2.el8.x86_64.rpm                                                                                             818 kB/s |  40 kB     00:00    
(97/143): gnupg2-2.2.9-1.el8.x86_64.rpm                                                                                                3.4 MB/s | 2.3 MB     00:00    
(98/143): initscripts-10.00.6-1.el8_2.2.x86_64.rpm                                                                                     2.1 MB/s | 338 kB     00:00    
(99/143): libcomps-0.1.11-4.el8.x86_64.rpm                                                                                             3.1 MB/s |  81 kB     00:00    
(100/143): libblkid-2.32.1-22.el8.x86_64.rpm                                                                                           1.5 MB/s | 214 kB     00:00    
(101/143): libevent-2.1.8-5.el8.x86_64.rpm                                                                                             1.3 MB/s | 253 kB     00:00    
(102/143): libgcrypt-1.8.3-4.el8.x86_64.rpm                                                                                            4.2 MB/s | 461 kB     00:00    
(103/143): libdnf-0.39.1-6.el8_2.x86_64.rpm                                                                                            2.4 MB/s | 620 kB     00:00    
(104/143): libmount-2.32.1-22.el8.x86_64.rpm                                                                                           4.6 MB/s | 231 kB     00:00    
(105/143): libnfsidmap-2.3.3-31.el8.x86_64.rpm                                                                                         4.9 MB/s | 118 kB     00:00    
(106/143): librepo-1.11.0-3.el8_2.x86_64.rpm                                                                                           5.5 MB/s |  90 kB     00:00    
(107/143): libsmartcols-2.32.1-22.el8.x86_64.rpm                                                                                       5.7 MB/s | 174 kB     00:00    
(108/143): libsolv-0.7.7-1.el8.x86_64.rpm                                                                                              7.2 MB/s | 356 kB     00:00    
(109/143): libtirpc-1.1.4-4.el8.x86_64.rpm                                                                                             3.9 MB/s | 113 kB     00:00    
(110/143): libgpg-error-1.31-1.el8.x86_64.rpm                                                                                          1.6 MB/s | 242 kB     00:00    
(111/143): libuuid-2.32.1-22.el8.x86_64.rpm                                                                                            1.7 MB/s |  94 kB     00:00    
(112/143): libstdc++-8.3.1-5.el8.0.2.x86_64.rpm                                                                                        2.3 MB/s | 451 kB     00:00    
(113/143): libverto-libevent-0.3.0-5.el8.x86_64.rpm                                                                                    1.6 MB/s |  16 kB     00:00    
(114/143): libunistring-0.9.9-3.el8.x86_64.rpm                                                                                         1.8 MB/s | 422 kB     00:00    
(115/143): libverto-0.3.0-5.el8.x86_64.rpm                                                                                             146 kB/s |  24 kB     00:00    
(116/143): ncurses-base-6.1-7.20180224.el8.noarch.rpm                                                                                  4.0 MB/s |  81 kB     00:00    
(117/143): ncurses-6.1-7.20180224.el8.x86_64.rpm                                                                                       6.0 MB/s | 387 kB     00:00    
(118/143): man-db-2.7.6.1-17.el8.x86_64.rpm                                                                                            4.0 MB/s | 887 kB     00:00    
(119/143): openssh-8.0p1-4.el8_1.x86_64.rpm                                                                                            6.5 MB/s | 496 kB     00:00    
(120/143): nfs-utils-2.3.3-31.el8.x86_64.rpm                                                                                           2.5 MB/s | 468 kB     00:00    
(121/143): ncurses-libs-6.1-7.20180224.el8.x86_64.rpm                                                                                  1.1 MB/s | 335 kB     00:00    
(122/143): openssh-clients-8.0p1-4.el8_1.x86_64.rpm                                                                                    3.3 MB/s | 704 kB     00:00    
(123/143): openssh-server-8.0p1-4.el8_1.x86_64.rpm                                                                                     2.5 MB/s | 485 kB     00:00    
(124/143): openssl-1.1.1c-15.el8.x86_64.rpm                                                                                            2.3 MB/s | 697 kB     00:00    
(125/143): parted-3.2-38.el8.x86_64.rpm                                                                                                2.3 MB/s | 557 kB     00:00    
(126/143): openssl-libs-1.1.1c-15.el8.x86_64.rpm                                                                                       4.5 MB/s | 1.5 MB     00:00    
(127/143): readline-7.0-10.el8.x86_64.rpm                                                                                              1.3 MB/s | 199 kB     00:00    
(128/143): rpcbind-1.2.5-7.el8.x86_64.rpm                                                                                              505 kB/s |  70 kB     00:00    
(129/143): rpm-build-libs-4.14.2-37.el8.x86_64.rpm                                                                                     3.0 MB/s | 154 kB     00:00    
(130/143): rpm-libs-4.14.2-37.el8.x86_64.rpm                                                                                           3.3 MB/s | 337 kB     00:00    
(131/143): rpm-4.14.2-37.el8.x86_64.rpm                                                                                                2.1 MB/s | 540 kB     00:00    
(132/143): sqlite-3.26.0-6.el8.x86_64.rpm                                                                                              2.8 MB/s | 666 kB     00:00    
(133/143): sudo-1.8.29-5.el8.x86_64.rpm                                                                                                2.9 MB/s | 923 kB     00:00    
(134/143): systemd-libs-239-31.el8_2.2.x86_64.rpm                                                                                      2.6 MB/s | 1.1 MB     00:00    
(135/143): tuned-2.13.0-6.el8.noarch.rpm                                                                                               2.1 MB/s | 281 kB     00:00    
(136/143): systemd-239-31.el8_2.2.x86_64.rpm                                                                                           3.7 MB/s | 3.5 MB     00:00    
(137/143): which-2.21-12.el8.x86_64.rpm                                                                                                972 kB/s |  49 kB     00:00    
(138/143): python3-libs-3.6.8-23.el8.x86_64.rpm                                                                                        4.0 MB/s | 7.8 MB     00:01    
(139/143): util-linux-2.32.1-22.el8.x86_64.rpm                                                                                         3.6 MB/s | 2.5 MB     00:00    
(140/143): xz-5.2.4-3.el8.x86_64.rpm                                                                                                   2.2 MB/s | 153 kB     00:00    
(141/143): xz-libs-5.2.4-3.el8.x86_64.rpm                                                                                              2.2 MB/s |  94 kB     00:00    
(142/143): xfsprogs-5.0.0-2.el8.x86_64.rpm                                                                                             2.5 MB/s | 1.1 MB     00:00    
(143/143): lua-5.3.4-11.el8.x86_64.rpm                                                                                                 3.2 MB/s | 193 kB     00:00    
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                  8.9 MB/s | 125 MB     00:14     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                1/1 
  Upgrading        : ncurses-base-6.1-7.20180224.el8.noarch                                                                                                       1/238 
  Installing       : python3-setuptools-wheel-39.2.0-5.el8.noarch                                                                                                 2/238 
  Installing       : python3-pip-wheel-9.0.3-16.el8.noarch                                                                                                        3/238 
  Upgrading        : glibc-common-2.28-101.el8.x86_64                                                                                                             4/238 
  Running scriptlet: glibc-2.28-101.el8.x86_64                                                                                                                    5/238 
  Upgrading        : glibc-2.28-101.el8.x86_64                                                                                                                    5/238 
  Running scriptlet: glibc-2.28-101.el8.x86_64                                                                                                                    5/238 
warning: /etc/nsswitch.conf created as /etc/nsswitch.conf.rpmnew

  Installing       : glibc-all-langpacks-2.28-101.el8.x86_64                                                                                                      6/238 
  Upgrading        : ncurses-libs-6.1-7.20180224.el8.x86_64                                                                                                       7/238 
  Upgrading        : grep-3.1-6.el8.x86_64                                                                                                                        8/238 
  Running scriptlet: grep-3.1-6.el8.x86_64                                                                                                                        8/238 
  Upgrading        : xz-libs-5.2.4-3.el8.x86_64                                                                                                                   9/238 
  Upgrading        : readline-7.0-10.el8.x86_64                                                                                                                  10/238 
  Running scriptlet: readline-7.0-10.el8.x86_64                                                                                                                  10/238 
  Upgrading        : libgpg-error-1.31-1.el8.x86_64                                                                                                              11/238 
  Installing       : sqlite-libs-3.26.0-6.el8.x86_64                                                                                                             12/238 
  Installing       : libxcrypt-4.1.1-4.el8.x86_64                                                                                                                13/238 
  Upgrading        : libuuid-2.32.1-22.el8.x86_64                                                                                                                14/238 
  Running scriptlet: libuuid-2.32.1-22.el8.x86_64                                                                                                                14/238 
  Upgrading        : libblkid-2.32.1-22.el8.x86_64                                                                                                               15/238 
  Running scriptlet: libblkid-2.32.1-22.el8.x86_64                                                                                                               15/238 
  Upgrading        : libmount-2.32.1-22.el8.x86_64                                                                                                               16/238 
  Running scriptlet: libmount-2.32.1-22.el8.x86_64                                                                                                               16/238 
  Installing       : lua-libs-5.3.4-11.el8.x86_64                                                                                                                17/238 
  Upgrading        : libstdc++-8.3.1-5.el8.0.2.x86_64                                                                                                            18/238 
  Running scriptlet: libstdc++-8.3.1-5.el8.0.2.x86_64                                                                                                            18/238 
  Upgrading        : libtirpc-1.1.4-4.el8.x86_64                                                                                                                 19/238 
  Running scriptlet: libtirpc-1.1.4-4.el8.x86_64                                                                                                                 19/238 
  Upgrading        : libgcrypt-1.8.3-4.el8.x86_64                                                                                                                20/238 
  Running scriptlet: libgcrypt-1.8.3-4.el8.x86_64                                                                                                                20/238 
  Upgrading        : systemd-libs-239-31.el8_2.2.x86_64                                                                                                          21/238 
  Running scriptlet: systemd-libs-239-31.el8_2.2.x86_64                                                                                                          21/238 
Detected system with nfsnobody defined, creating /etc/systemd/dont-synthesize-nobody

  Installing       : libzstd-1.4.2-2.el8.x86_64                                                                                                                  22/238 
  Installing       : gdbm-libs-1:1.18-1.el8.x86_64                                                                                                               23/238 
  Upgrading        : json-c-0.13.1-0.2.el8.x86_64                                                                                                                24/238 
  Upgrading        : libsmartcols-2.32.1-22.el8.x86_64                                                                                                           25/238 
  Running scriptlet: libsmartcols-2.32.1-22.el8.x86_64                                                                                                           25/238 
  Upgrading        : libunistring-0.9.9-3.el8.x86_64                                                                                                             26/238 
  Installing       : ipcalc-0.2.4-4.el8.x86_64                                                                                                                   27/238 
  Installing       : libidn2-2.2.0-1.el8.x86_64                                                                                                                  28/238 
  Upgrading        : gdbm-1:1.18-1.el8.x86_64                                                                                                                    29/238 
  Installing       : libnsl2-1.2.0-2.20180605git4a062cf.el8.x86_64                                                                                               30/238 
  Running scriptlet: libnsl2-1.2.0-2.20180605git4a062cf.el8.x86_64                                                                                               30/238 
  Installing       : platform-python-setuptools-39.2.0-5.el8.noarch                                                                                              31/238 
  Installing       : platform-python-3.6.8-23.el8.x86_64                                                                                                         32/238 
  Running scriptlet: platform-python-3.6.8-23.el8.x86_64                                                                                                         32/238 
  Installing       : crypto-policies-20191128-2.git23e1bf1.el8.noarch                                                                                            33/238 
  Upgrading        : openssl-libs-1:1.1.1c-15.el8.x86_64                                                                                                         34/238 
  Running scriptlet: openssl-libs-1:1.1.1c-15.el8.x86_64                                                                                                         34/238 
  Upgrading        : python3-libs-3.6.8-23.el8.x86_64                                                                                                            35/238 
  Upgrading        : libevent-2.1.8-5.el8.x86_64                                                                                                                 36/238 
  Installing       : python3-six-1.11.0-8.el8.noarch                                                                                                             37/238 
  Installing       : ima-evm-utils-1.1-5.el8.x86_64                                                                                                              38/238 
  Upgrading        : cryptsetup-libs-2.2.2-1.el8.x86_64                                                                                                          39/238 
  Running scriptlet: cryptsetup-libs-2.2.2-1.el8.x86_64                                                                                                          39/238 
  Installing       : libksba-1.3.5-7.el8.x86_64                                                                                                                  40/238 
  Installing       : psmisc-23.1-4.el8.x86_64                                                                                                                    41/238 
  Installing       : python3-configobj-5.0.6-11.el8.noarch                                                                                                       42/238 
  Installing       : python3-linux-procfs-0.6-7.el8.noarch                                                                                                       43/238 
  Installing       : python3-pyudev-0.21.0-7.el8.noarch                                                                                                          44/238 
  Installing       : python3-perf-4.18.0-193.28.1.el8_2.x86_64                                                                                                   45/238 
  Installing       : python3-schedutils-0.6-6.el8.x86_64                                                                                                         46/238 
  Installing       : libarchive-3.3.2-8.el8_1.x86_64                                                                                                             47/238 
  Upgrading        : rpm-4.14.2-37.el8.x86_64                                                                                                                    48/238 
  Upgrading        : rpm-libs-4.14.2-37.el8.x86_64                                                                                                               49/238 
  Running scriptlet: rpm-libs-4.14.2-37.el8.x86_64                                                                                                               49/238 
  Upgrading        : libsolv-0.7.7-1.el8.x86_64                                                                                                                  50/238 
  Installing       : trousers-lib-0.3.14-4.el8.x86_64                                                                                                            51/238 
  Running scriptlet: trousers-lib-0.3.14-4.el8.x86_64                                                                                                            51/238 
  Upgrading        : bind-export-libs-32:9.11.13-6.el8_2.1.x86_64                                                                                                52/238 
  Running scriptlet: bind-export-libs-32:9.11.13-6.el8_2.1.x86_64                                                                                                52/238 
  Upgrading        : openssl-1:1.1.1c-15.el8.x86_64                                                                                                              53/238 
  Installing       : python3-dbus-1.2.4-15.el8.x86_64                                                                                                            54/238 
  Installing       : python3-decorator-4.2.1-2.el8.noarch                                                                                                        55/238 
  Installing       : python3-gobject-base-3.28.3-1.el8.x86_64                                                                                                    56/238 
  Installing       : python3-syspurpose-1.26.20-1.el8_2.x86_64                                                                                                   57/238 
  Upgrading        : gettext-libs-0.19.8.1-17.el8.x86_64                                                                                                         58/238 
  Installing       : libusbx-1.0.22-1.el8.x86_64                                                                                                                 59/238 
  Upgrading        : dhcp-libs-12:4.3.6-40.el8.x86_64                                                                                                            60/238 
  Upgrading        : libnfsidmap-1:2.3.3-31.el8.x86_64                                                                                                           61/238 
  Installing       : libfdisk-2.32.1-22.el8.x86_64                                                                                                               62/238 
  Running scriptlet: libfdisk-2.32.1-22.el8.x86_64                                                                                                               62/238 
  Upgrading        : util-linux-2.32.1-22.el8.x86_64                                                                                                             63/238 
  Running scriptlet: util-linux-2.32.1-22.el8.x86_64                                                                                                             63/238 
  Running scriptlet: openssh-8.0p1-4.el8_1.x86_64                                                                                                                64/238 
  Upgrading        : openssh-8.0p1-4.el8_1.x86_64                                                                                                                64/238 
  Installing       : vim-minimal-2:8.0.1763-13.el8.x86_64                                                                                                        65/238 
warning: /etc/virc created as /etc/virc.rpmnew

  Installing       : hdparm-9.54-2.el8.x86_64                                                                                                                    66/238 
  Installing       : libpcap-14:1.9.0-3.el8.x86_64                                                                                                               67/238 
  Installing       : iptables-libs-1.8.4-10.el8_2.1.x86_64                                                                                                       68/238 
  Installing       : nettle-3.4.1-1.el8.x86_64                                                                                                                   69/238 
  Running scriptlet: nettle-3.4.1-1.el8.x86_64                                                                                                                   69/238 
  Installing       : gnutls-3.6.8-11.el8_2.x86_64                                                                                                                70/238 
  Installing       : npth-1.5-4.el8.x86_64                                                                                                                       71/238 
  Upgrading        : gnupg2-2.2.9-1.el8.x86_64                                                                                                                   72/238 
  Upgrading        : gpgme-1.10.0-6.el8.0.1.x86_64                                                                                                               73/238 
  Upgrading        : librepo-1.11.0-3.el8_2.x86_64                                                                                                               74/238 
  Upgrading        : libdnf-0.39.1-6.el8_2.x86_64                                                                                                                75/238 
  Installing       : python3-libdnf-0.39.1-6.el8_2.x86_64                                                                                                        76/238 
  Installing       : python3-hawkey-0.39.1-6.el8_2.x86_64                                                                                                        77/238 
  Installing       : python3-gpg-1.10.0-6.el8.0.1.x86_64                                                                                                         78/238 
  Upgrading        : rpm-build-libs-4.14.2-37.el8.x86_64                                                                                                         79/238 
  Running scriptlet: rpm-build-libs-4.14.2-37.el8.x86_64                                                                                                         79/238 
  Installing       : python3-rpm-4.14.2-37.el8.x86_64                                                                                                            80/238 
  Installing       : pcre2-10.32-1.el8.x86_64                                                                                                                    81/238 
  Installing       : systemd-pam-239-31.el8_2.2.x86_64                                                                                                           82/238 
  Running scriptlet: systemd-239-31.el8_2.2.x86_64                                                                                                               83/238 
  Upgrading        : systemd-239-31.el8_2.2.x86_64                                                                                                               83/238 
  Running scriptlet: systemd-239-31.el8_2.2.x86_64                                                                                                               83/238 
warning: /etc/systemd/logind.conf created as /etc/systemd/logind.conf.rpmnew

  Upgrading        : initscripts-10.00.6-1.el8_2.2.x86_64                                                                                                        84/238 
  Running scriptlet: initscripts-10.00.6-1.el8_2.2.x86_64                                                                                                        84/238 
  Installing       : network-scripts-10.00.6-1.el8_2.2.x86_64                                                                                                    85/238 
  Running scriptlet: network-scripts-10.00.6-1.el8_2.2.x86_64                                                                                                    85/238 
  Running scriptlet: authselect-libs-1.1-2.el8.x86_64                                                                                                            86/238 
  Installing       : authselect-libs-1.1-2.el8.x86_64                                                                                                            86/238 
  Installing       : authselect-1.1-2.el8.x86_64                                                                                                                 87/238 
  Installing       : oddjob-0.34.4-7.el8.x86_64                                                                                                                  88/238 
  Running scriptlet: oddjob-0.34.4-7.el8.x86_64                                                                                                                  88/238 
  Running scriptlet: unbound-libs-1.7.3-11.el8_2.x86_64                                                                                                          89/238 
  Installing       : unbound-libs-1.7.3-11.el8_2.x86_64                                                                                                          89/238 
  Running scriptlet: unbound-libs-1.7.3-11.el8_2.x86_64                                                                                                          89/238 
  Running scriptlet: rpcbind-1.2.5-7.el8.x86_64                                                                                                                  90/238 
  Upgrading        : rpcbind-1.2.5-7.el8.x86_64                                                                                                                  90/238 
  Running scriptlet: rpcbind-1.2.5-7.el8.x86_64                                                                                                                  90/238 
  Upgrading        : libcomps-0.1.11-4.el8.x86_64                                                                                                                91/238 
  Installing       : python3-libcomps-0.1.11-4.el8.x86_64                                                                                                        92/238 
  Upgrading        : libverto-0.3.0-5.el8.x86_64                                                                                                                 93/238 
  Upgrading        : dnf-data-4.2.17-7.el8_2.noarch                                                                                                              94/238 
  Installing       : python3-dnf-4.2.17-7.el8_2.noarch                                                                                                           95/238 
  Upgrading        : dhcp-common-12:4.3.6-40.el8.noarch                                                                                                          96/238 
  Installing       : xkeyboard-config-2.28-1.el8.noarch                                                                                                          97/238 
  Installing       : python2-setuptools-wheel-39.0.1-11.module_el8.2.0+381+9a5b3c3b.noarch                                                                       98/238 
  Installing       : python2-pip-wheel-9.0.3-16.module_el8.2.0+381+9a5b3c3b.noarch                                                                               99/238 
  Installing       : python2-2.7.17-1.module_el8.2.0+381+9a5b3c3b.x86_64                                                                                        100/238 
  Running scriptlet: python2-2.7.17-1.module_el8.2.0+381+9a5b3c3b.x86_64                                                                                        100/238 
  Installing       : python2-libs-2.7.17-1.module_el8.2.0+381+9a5b3c3b.x86_64                                                                                   101/238 
  Installing       : python2-setuptools-39.0.1-11.module_el8.2.0+381+9a5b3c3b.noarch                                                                            102/238 
  Installing       : python2-pip-9.0.3-16.module_el8.2.0+381+9a5b3c3b.noarch                                                                                    103/238 
  Installing       : libxkbcommon-0.9.1-1.el8.x86_64                                                                                                            104/238 
  Installing       : dhcp-client-12:4.3.6-40.el8.x86_64                                                                                                         105/238 
warning: /etc/dhcp/dhclient.conf created as /etc/dhcp/dhclient.conf.rpmnew

  Upgrading        : dnf-4.2.17-7.el8_2.noarch                                                                                                                  106/238 
  Running scriptlet: dnf-4.2.17-7.el8_2.noarch                                                                                                                  106/238 
  Upgrading        : libverto-libevent-0.3.0-5.el8.x86_64                                                                                                       107/238 
  Running scriptlet: nfs-utils-1:2.3.3-31.el8.x86_64                                                                                                            108/238 
  Upgrading        : nfs-utils-1:2.3.3-31.el8.x86_64                                                                                                            108/238 
  Running scriptlet: nfs-utils-1:2.3.3-31.el8.x86_64                                                                                                            108/238 
  Installing       : python3-unbound-1.7.3-11.el8_2.x86_64                                                                                                      109/238 
  Installing       : oddjob-mkhomedir-0.34.4-7.el8.x86_64                                                                                                       110/238 
  Running scriptlet: oddjob-mkhomedir-0.34.4-7.el8.x86_64                                                                                                       110/238 
  Installing       : authselect-compat-1.1-2.el8.x86_64                                                                                                         111/238 
  Installing       : network-scripts-team-1.29-1.el8_2.2.x86_64                                                                                                 112/238 
  Installing       : netconsole-service-10.00.6-1.el8_2.2.noarch                                                                                                113/238 
  Running scriptlet: netconsole-service-10.00.6-1.el8_2.2.noarch                                                                                                113/238 
  Installing       : readonly-root-10.00.6-1.el8_2.2.noarch                                                                                                     114/238 
  Running scriptlet: readonly-root-10.00.6-1.el8_2.2.noarch                                                                                                     114/238 
  Installing       : systemd-container-239-31.el8_2.2.x86_64                                                                                                    115/238 
  Installing       : systemd-udev-239-31.el8_2.2.x86_64                                                                                                         116/238 
  Running scriptlet: systemd-udev-239-31.el8_2.2.x86_64                                                                                                         116/238 
  Running scriptlet: trousers-0.3.14-4.el8.x86_64                                                                                                               117/238 
  Installing       : trousers-0.3.14-4.el8.x86_64                                                                                                               117/238 
  Running scriptlet: trousers-0.3.14-4.el8.x86_64                                                                                                               117/238 
  Running scriptlet: openssh-server-8.0p1-4.el8_1.x86_64                                                                                                        118/238 
  Upgrading        : openssh-server-8.0p1-4.el8_1.x86_64                                                                                                        118/238 
  Running scriptlet: openssh-server-8.0p1-4.el8_1.x86_64                                                                                                        118/238 
warning: /etc/ssh/sshd_config created as /etc/ssh/sshd_config.rpmnew

  Upgrading        : tuned-2.13.0-6.el8.noarch                                                                                                                  119/238 
  Running scriptlet: tuned-2.13.0-6.el8.noarch                                                                                                                  119/238 
  Installing       : gnupg2-smime-2.2.9-1.el8.x86_64                                                                                                            120/238 
  Upgrading        : sudo-1.8.29-5.el8.x86_64                                                                                                                   121/238 
  Running scriptlet: sudo-1.8.29-5.el8.x86_64                                                                                                                   121/238 
  Upgrading        : openssh-clients-8.0p1-4.el8_1.x86_64                                                                                                       122/238 
  Upgrading        : gettext-0.19.8.1-17.el8.x86_64                                                                                                             123/238 
  Running scriptlet: gettext-0.19.8.1-17.el8.x86_64                                                                                                             123/238 
  Installing       : openssl-pkcs11-0.4.10-2.el8.x86_64                                                                                                         124/238 
  Installing       : rpm-plugin-systemd-inhibit-4.14.2-37.el8.x86_64                                                                                            125/238 
  Installing       : compat-openssl10-1:1.0.2o-3.el8.x86_64                                                                                                     126/238 
  Running scriptlet: compat-openssl10-1:1.0.2o-3.el8.x86_64                                                                                                     126/238 
  Installing       : platform-python-pip-9.0.3-16.el8.noarch                                                                                                    127/238 
  Running scriptlet: man-db-2.7.6.1-17.el8.x86_64                                                                                                               128/238 
  Upgrading        : man-db-2.7.6.1-17.el8.x86_64                                                                                                               128/238 
  Running scriptlet: man-db-2.7.6.1-17.el8.x86_64                                                                                                               128/238 
  Installing       : ncurses-compat-libs-6.1-7.20180224.el8.x86_64                                                                                              129/238 
  Upgrading        : binutils-2.30-73.el8.x86_64                                                                                                                130/238 
  Running scriptlet: binutils-2.30-73.el8.x86_64                                                                                                                130/238 
  Upgrading        : lua-5.3.4-11.el8.x86_64                                                                                                                    131/238 
  Upgrading        : parted-3.2-38.el8.x86_64                                                                                                                   132/238 
  Running scriptlet: parted-3.2-38.el8.x86_64                                                                                                                   132/238 
  Upgrading        : xfsprogs-5.0.0-2.el8.x86_64                                                                                                                133/238 
  Running scriptlet: xfsprogs-5.0.0-2.el8.x86_64                                                                                                                133/238 
  Upgrading        : sqlite-3.26.0-6.el8.x86_64                                                                                                                 134/238 
  Upgrading        : bc-1.07.1-5.el8.x86_64                                                                                                                     135/238 
  Running scriptlet: bc-1.07.1-5.el8.x86_64                                                                                                                     135/238 
  Upgrading        : xz-5.2.4-3.el8.x86_64                                                                                                                      136/238 
  Upgrading        : ncurses-6.1-7.20180224.el8.x86_64                                                                                                          137/238 
  Installing       : libnsl-2.28-101.el8.x86_64                                                                                                                 138/238 
  Installing       : libmaxminddb-1.2.0-7.el8.x86_64                                                                                                            139/238 
  Running scriptlet: libmaxminddb-1.2.0-7.el8.x86_64                                                                                                            139/238 
  Upgrading        : which-2.21-12.el8.x86_64                                                                                                                   140/238 
  Installing       : geolite2-country-20180605-1.el8.noarch                                                                                                     141/238 
  Installing       : geolite2-city-20180605-1.el8.noarch                                                                                                        142/238 
  Installing       : centos-obsolete-packages-8-4.noarch                                                                                                        143/238 
  Obsoleting       : dhclient-12:4.2.5-82.el7.centos.x86_64                                                                                                     144/238 
  Running scriptlet: nfs-utils-1:1.3.0-0.68.el7.x86_64                                                                                                          145/238 
  Cleanup          : nfs-utils-1:1.3.0-0.68.el7.x86_64                                                                                                          145/238 
  Running scriptlet: nfs-utils-1:1.3.0-0.68.el7.x86_64                                                                                                          145/238 
  Running scriptlet: cloud-init-19.4-7.el7.centos.2.x86_64                                                                                                      146/238 
  Erasing          : cloud-init-19.4-7.el7.centos.2.x86_64                                                                                                      146/238 
  Running scriptlet: cloud-init-19.4-7.el7.centos.2.x86_64                                                                                                      146/238 
  Erasing          : python36-rpm-4.11.3-8.el7.x86_64                                                                                                           147/238 
  Erasing          : python3-3.6.8-18.el7.x86_64                                                                                                                148/238 
  Cleanup          : python3-libs-3.6.8-18.el7.x86_64                                                                                                           149/238 
  Erasing          : libxml2-python-2.9.1-6.el7.5.x86_64                                                                                                        150/238 
  Running scriptlet: openssh-server-7.4p1-21.el7.x86_64                                                                                                         151/238 
  Cleanup          : openssh-server-7.4p1-21.el7.x86_64                                                                                                         151/238 
  Running scriptlet: openssh-server-7.4p1-21.el7.x86_64                                                                                                         151/238 
  Running scriptlet: rpcbind-0.2.0-49.el7.x86_64                                                                                                                152/238 
  Cleanup          : rpcbind-0.2.0-49.el7.x86_64                                                                                                                152/238 
  Running scriptlet: rpcbind-0.2.0-49.el7.x86_64                                                                                                                152/238 
  Cleanup          : xfsprogs-4.5.0-22.el7.x86_64                                                                                                               153/238 
  Running scriptlet: xfsprogs-4.5.0-22.el7.x86_64                                                                                                               153/238 
  Running scriptlet: parted-3.1-32.el7.x86_64                                                                                                                   154/238 
  Cleanup          : parted-3.1-32.el7.x86_64                                                                                                                   154/238 
  Running scriptlet: parted-3.1-32.el7.x86_64                                                                                                                   154/238 
  Cleanup          : openssh-clients-7.4p1-21.el7.x86_64                                                                                                        155/238 
  Running scriptlet: tuned-2.11.0-10.el7.noarch                                                                                                                 156/238 
  Cleanup          : tuned-2.11.0-10.el7.noarch                                                                                                                 156/238 
  Running scriptlet: tuned-2.11.0-10.el7.noarch                                                                                                                 156/238 
  Erasing          : policycoreutils-python-2.5-34.el7.x86_64                                                                                                   157/238 
  Erasing          : python-schedutils-0.4-6.el7.x86_64                                                                                                         158/238 
  Running scriptlet: initscripts-9.49.53-1.el7_9.1.x86_64                                                                                                       159/238 
  Cleanup          : initscripts-9.49.53-1.el7_9.1.x86_64                                                                                                       159/238 
  Running scriptlet: initscripts-9.49.53-1.el7_9.1.x86_64                                                                                                       159/238 
  Running scriptlet: bc-1.06.95-13.el7.x86_64                                                                                                                   160/238 
  Cleanup          : bc-1.06.95-13.el7.x86_64                                                                                                                   160/238 
  Cleanup          : libverto-libevent-0.2.5-4.el7.x86_64                                                                                                       161/238 
  Running scriptlet: libverto-libevent-0.2.5-4.el7.x86_64                                                                                                       161/238 
  Cleanup          : libevent-2.0.21-4.el7.x86_64                                                                                                               162/238 
  Running scriptlet: libevent-2.0.21-4.el7.x86_64                                                                                                               162/238 
  Obsoleting       : authconfig-6.2.8-30.el7.x86_64                                                                                                             163/238 
warning: /etc/sysconfig/authconfig saved as /etc/sysconfig/authconfig.rpmsave

  Running scriptlet: dnf-4.0.9.2-1.el7_6.noarch                                                                                                                 164/238 
  Cleanup          : dnf-4.0.9.2-1.el7_6.noarch                                                                                                                 164/238 
  Running scriptlet: dnf-4.0.9.2-1.el7_6.noarch                                                                                                                 164/238 
  Erasing          : python2-dnf-4.0.9.2-1.el7_6.noarch                                                                                                         165/238 
  Obsoleting       : python2-hawkey-0.22.5-2.el7_9.x86_64                                                                                                       166/238 
  Obsoleting       : python2-libdnf-0.22.5-2.el7_9.x86_64                                                                                                       167/238 
  Cleanup          : libdnf-0.22.5-2.el7_9.x86_64                                                                                                               168/238 
  Running scriptlet: libdnf-0.22.5-2.el7_9.x86_64                                                                                                               168/238 
  Erasing          : rpm-python-4.11.3-45.el7.x86_64                                                                                                            169/238 
  Cleanup          : librepo-1.8.1-8.el7_9.x86_64                                                                                                               170/238 
  Running scriptlet: librepo-1.8.1-8.el7_9.x86_64                                                                                                               170/238 
  Cleanup          : rpm-build-libs-4.11.3-45.el7.x86_64                                                                                                        171/238 
  Running scriptlet: rpm-build-libs-4.11.3-45.el7.x86_64                                                                                                        171/238 
  Erasing          : python2-libcomps-0.1.8-14.el7.x86_64                                                                                                       172/238 
  Cleanup          : gpgme-1.3.2-5.el7.x86_64                                                                                                                   173/238 
  Running scriptlet: gpgme-1.3.2-5.el7.x86_64                                                                                                                   173/238 
  Running scriptlet: gnupg2-2.0.22-5.el7_5.x86_64                                                                                                               174/238 
  Cleanup          : gnupg2-2.0.22-5.el7_5.x86_64                                                                                                               174/238 
  Cleanup          : openssl-1:1.0.2k-19.el7.x86_64                                                                                                             175/238 
  Cleanup          : libsolv-0.6.34-4.el7.x86_64                                                                                                                176/238 
  Running scriptlet: libsolv-0.6.34-4.el7.x86_64                                                                                                                176/238 
  Erasing          : deltarpm-3.6-3.el7.x86_64                                                                                                                  177/238 
  Erasing          : libsemanage-python-2.5-14.el7.x86_64                                                                                                       178/238 
  Cleanup          : openssh-7.4p1-21.el7.x86_64                                                                                                                179/238 
  Cleanup          : util-linux-2.23.2-65.el7.x86_64                                                                                                            180/238 
  Erasing          : pyxattr-0.5.1-5.el7.x86_64                                                                                                                 181/238 
  Cleanup          : xz-5.2.2-1.el7.x86_64                                                                                                                      182/238 
  Cleanup          : man-db-2.6.3-11.el7.x86_64                                                                                                                 183/238 
  Cleanup          : bind-export-libs-32:9.11.4-26.P2.el7_9.2.x86_64                                                                                            184/238 
  Running scriptlet: bind-export-libs-32:9.11.4-26.P2.el7_9.2.x86_64                                                                                            184/238 
  Cleanup          : sudo-1.8.23-10.el7.x86_64                                                                                                                  185/238 
  Cleanup          : ncurses-5.9-14.20130511.el7_4.x86_64                                                                                                       186/238 
  Erasing          : systemd-sysv-219-78.el7_9.2.x86_64                                                                                                         187/238 
  Erasing          : python-jsonpatch-1.2-4.el7.noarch                                                                                                          188/238 
  Erasing          : python-requests-2.6.0-10.el7.noarch                                                                                                        189/238 
  Erasing          : python-kitchen-1.1.1-5.el7.noarch                                                                                                          190/238 
  Erasing          : python-chardet-2.2.1-3.el7.noarch                                                                                                          191/238 
  Erasing          : python-jsonpointer-1.9-2.el7.noarch                                                                                                        192/238 
  Erasing          : python-linux-procfs-0.4.11-4.el7.noarch                                                                                                    193/238 
  Erasing          : pyserial-2.6-6.el7.noarch                                                                                                                  194/238 
  Erasing          : python-setuptools-0.9.8-7.el7.noarch                                                                                                       195/238 
  Cleanup          : dhcp-common-12:4.2.5-82.el7.centos.x86_64                                                                                                  196/238 
  Cleanup          : dhcp-libs-12:4.2.5-82.el7.centos.x86_64                                                                                                    197/238 
  Running scriptlet: dhcp-libs-12:4.2.5-82.el7.centos.x86_64                                                                                                    197/238 
  Erasing          : python-urlgrabber-3.10-10.el7.noarch                                                                                                       198/238 
  Erasing          : grub2-1:2.02-0.86.el7.centos.x86_64                                                                                                        199/238 
  Running scriptlet: systemd-219-78.el7_9.2.x86_64                                                                                                              200/238 
  Cleanup          : systemd-219-78.el7_9.2.x86_64                                                                                                              200/238 
warning: file /etc/yum/protected.d/systemd.conf: remove failed: No such file or directory

  Running scriptlet: systemd-219-78.el7_9.2.x86_64                                                                                                              200/238 
  Erasing          : grub2-pc-1:2.02-0.86.el7.centos.x86_64                                                                                                     201/238 
  Cleanup          : cryptsetup-libs-2.0.3-6.el7.x86_64                                                                                                         202/238 
  Running scriptlet: cryptsetup-libs-2.0.3-6.el7.x86_64                                                                                                         202/238 
  Erasing          : grub2-tools-extra-1:2.02-0.86.el7.centos.x86_64                                                                                            203/238 
  Running scriptlet: grub2-tools-1:2.02-0.86.el7.centos.x86_64                                                                                                  204/238 
install-info: warning: no entries found for `/usr/share/info/grub2.info.gz'; nothing deleted
install-info: warning: no entries found for `/usr/share/info/grub2-dev.info.gz'; nothing deleted

  Erasing          : grub2-tools-1:2.02-0.86.el7.centos.x86_64                                                                                                  204/238 
  Running scriptlet: gettext-0.19.8.1-3.el7.x86_64                                                                                                              205/238 
  Cleanup          : gettext-0.19.8.1-3.el7.x86_64                                                                                                              205/238 
  Running scriptlet: gettext-0.19.8.1-3.el7.x86_64                                                                                                              205/238 
  Cleanup          : gettext-libs-0.19.8.1-3.el7.x86_64                                                                                                         206/238 
  Running scriptlet: gettext-libs-0.19.8.1-3.el7.x86_64                                                                                                         206/238 
  Cleanup          : rpm-libs-4.11.3-45.el7.x86_64                                                                                                              207/238 
  Running scriptlet: rpm-libs-4.11.3-45.el7.x86_64                                                                                                              207/238 
  Cleanup          : rpm-4.11.3-45.el7.x86_64                                                                                                                   208/238 
  Cleanup          : lua-5.1.4-15.el7.x86_64                                                                                                                    209/238 
  Erasing          : python-2.7.5-90.el7.x86_64                                                                                                                 210/238 
warning: file /usr/bin/python: remove failed: No such file or directory

  Erasing          : python-libs-2.7.5-90.el7.x86_64                                                                                                            211/238 
  Running scriptlet: python-libs-2.7.5-90.el7.x86_64                                                                                                            211/238 
  Cleanup          : sqlite-3.7.17-8.el7_7.1.x86_64                                                                                                             212/238 
  Running scriptlet: sqlite-3.7.17-8.el7_7.1.x86_64                                                                                                             212/238 
  Cleanup          : libmount-2.23.2-65.el7.x86_64                                                                                                              213/238 
  Running scriptlet: libmount-2.23.2-65.el7.x86_64                                                                                                              213/238 
  Cleanup          : systemd-libs-219-78.el7_9.2.x86_64                                                                                                         214/238 
  Running scriptlet: systemd-libs-219-78.el7_9.2.x86_64                                                                                                         214/238 
  Cleanup          : libgcrypt-1.5.3-14.el7.x86_64                                                                                                              215/238 
  Running scriptlet: libgcrypt-1.5.3-14.el7.x86_64                                                                                                              215/238 
  Cleanup          : libblkid-2.23.2-65.el7.x86_64                                                                                                              216/238 
  Running scriptlet: libblkid-2.23.2-65.el7.x86_64                                                                                                              216/238 
  Running scriptlet: readline-6.2-11.el7.x86_64                                                                                                                 217/238 
  Cleanup          : readline-6.2-11.el7.x86_64                                                                                                                 217/238 
  Running scriptlet: readline-6.2-11.el7.x86_64                                                                                                                 217/238 
  Cleanup          : ncurses-libs-5.9-14.20130511.el7_4.x86_64                                                                                                  218/238 
  Running scriptlet: ncurses-libs-5.9-14.20130511.el7_4.x86_64                                                                                                  218/238 
  Cleanup          : libstdc++-4.8.5-44.el7.x86_64                                                                                                              219/238 
  Running scriptlet: libstdc++-4.8.5-44.el7.x86_64                                                                                                              219/238 
  Cleanup          : libuuid-2.23.2-65.el7.x86_64                                                                                                               220/238 
  Running scriptlet: libuuid-2.23.2-65.el7.x86_64                                                                                                               220/238 
  Cleanup          : libgpg-error-1.12-3.el7.x86_64                                                                                                             221/238 
  Running scriptlet: libgpg-error-1.12-3.el7.x86_64                                                                                                             221/238 
  Cleanup          : xz-libs-5.2.2-1.el7.x86_64                                                                                                                 222/238 
  Running scriptlet: xz-libs-5.2.2-1.el7.x86_64                                                                                                                 222/238 
  Cleanup          : openssl-libs-1:1.0.2k-19.el7.x86_64                                                                                                        223/238 
  Running scriptlet: openssl-libs-1:1.0.2k-19.el7.x86_64                                                                                                        223/238 
  Cleanup          : gdbm-1.10-8.el7.x86_64                                                                                                                     224/238 
  Running scriptlet: gdbm-1.10-8.el7.x86_64                                                                                                                     224/238 
  Cleanup          : libunistring-0.9.3-9.el7.x86_64                                                                                                            225/238 
  Running scriptlet: libunistring-0.9.3-9.el7.x86_64                                                                                                            225/238 
  Running scriptlet: which-2.20-7.el7.x86_64                                                                                                                    226/238 
  Cleanup          : which-2.20-7.el7.x86_64                                                                                                                    226/238 
  Cleanup          : json-c-0.11-4.el7_0.x86_64                                                                                                                 227/238 
  Running scriptlet: json-c-0.11-4.el7_0.x86_64                                                                                                                 227/238 
  Running scriptlet: grep-2.20-3.el7.x86_64                                                                                                                     228/238 
  Cleanup          : grep-2.20-3.el7.x86_64                                                                                                                     228/238 
  Cleanup          : libsmartcols-2.23.2-65.el7.x86_64                                                                                                          229/238 
  Running scriptlet: libsmartcols-2.23.2-65.el7.x86_64                                                                                                          229/238 
  Cleanup          : libcomps-0.1.8-14.el7.x86_64                                                                                                               230/238 
  Running scriptlet: libcomps-0.1.8-14.el7.x86_64                                                                                                               230/238 
  Cleanup          : libverto-0.2.5-4.el7.x86_64                                                                                                                231/238 
  Running scriptlet: libverto-0.2.5-4.el7.x86_64                                                                                                                231/238 
  Cleanup          : libtirpc-0.2.4-0.16.el7.x86_64                                                                                                             232/238 
  Running scriptlet: libtirpc-0.2.4-0.16.el7.x86_64                                                                                                             232/238 
  Cleanup          : libnfsidmap-0.25-19.el7.x86_64                                                                                                             233/238 
  Running scriptlet: libnfsidmap-0.25-19.el7.x86_64                                                                                                             233/238 
  Running scriptlet: binutils-2.27-44.base.el7.x86_64                                                                                                           234/238 
  Cleanup          : binutils-2.27-44.base.el7.x86_64                                                                                                           234/238 
  Running scriptlet: binutils-2.27-44.base.el7.x86_64                                                                                                           234/238 
  Cleanup          : ncurses-base-5.9-14.20130511.el7_4.noarch                                                                                                  235/238 
  Cleanup          : dnf-data-4.0.9.2-1.el7_6.noarch                                                                                                            236/238 
  Cleanup          : glibc-common-2.17-317.el7.x86_64                                                                                                           237/238 
  Cleanup          : glibc-2.17-317.el7.x86_64                                                                                                                  238/238 
  Running scriptlet: glibc-2.17-317.el7.x86_64                                                                                                                  238/238 
  Running scriptlet: glibc-all-langpacks-2.28-101.el8.x86_64                                                                                                    238/238 
  Running scriptlet: crypto-policies-20191128-2.git23e1bf1.el8.noarch                                                                                           238/238 
  Running scriptlet: authselect-libs-1.1-2.el8.x86_64                                                                                                           238/238 
  Running scriptlet: authselect-compat-1.1-2.el8.x86_64                                                                                                         238/238 
  Running scriptlet: tuned-2.13.0-6.el8.noarch                                                                                                                  238/238 
  Verifying        : authselect-1.1-2.el8.x86_64                                                                                                                  1/238 
  Verifying        : authselect-libs-1.1-2.el8.x86_64                                                                                                             2/238 
  Verifying        : centos-obsolete-packages-8-4.noarch                                                                                                          3/238 
  Verifying        : crypto-policies-20191128-2.git23e1bf1.el8.noarch                                                                                             4/238 
  Verifying        : dhcp-client-12:4.3.6-40.el8.x86_64                                                                                                           5/238 
  Verifying        : dhclient-12:4.2.5-82.el7.centos.x86_64                                                                                                       6/238 
  Verifying        : gdbm-libs-1:1.18-1.el8.x86_64                                                                                                                7/238 
  Verifying        : glibc-all-langpacks-2.28-101.el8.x86_64                                                                                                      8/238 
  Verifying        : gnupg2-smime-2.2.9-1.el8.x86_64                                                                                                              9/238 
  Verifying        : gnutls-3.6.8-11.el8_2.x86_64                                                                                                                10/238 
  Verifying        : hdparm-9.54-2.el8.x86_64                                                                                                                    11/238 
  Verifying        : ima-evm-utils-1.1-5.el8.x86_64                                                                                                              12/238 
  Verifying        : ipcalc-0.2.4-4.el8.x86_64                                                                                                                   13/238 
  Verifying        : iptables-libs-1.8.4-10.el8_2.1.x86_64                                                                                                       14/238 
  Verifying        : libarchive-3.3.2-8.el8_1.x86_64                                                                                                             15/238 
  Verifying        : libfdisk-2.32.1-22.el8.x86_64                                                                                                               16/238 
  Verifying        : libidn2-2.2.0-1.el8.x86_64                                                                                                                  17/238 
  Verifying        : libksba-1.3.5-7.el8.x86_64                                                                                                                  18/238 
  Verifying        : libnsl-2.28-101.el8.x86_64                                                                                                                  19/238 
  Verifying        : libnsl2-1.2.0-2.20180605git4a062cf.el8.x86_64                                                                                               20/238 
  Verifying        : libpcap-14:1.9.0-3.el8.x86_64                                                                                                               21/238 
  Verifying        : libusbx-1.0.22-1.el8.x86_64                                                                                                                 22/238 
  Verifying        : libxcrypt-4.1.1-4.el8.x86_64                                                                                                                23/238 
  Verifying        : libzstd-1.4.2-2.el8.x86_64                                                                                                                  24/238 
  Verifying        : lua-libs-5.3.4-11.el8.x86_64                                                                                                                25/238 
  Verifying        : ncurses-compat-libs-6.1-7.20180224.el8.x86_64                                                                                               26/238 
  Verifying        : netconsole-service-10.00.6-1.el8_2.2.noarch                                                                                                 27/238 
  Verifying        : nettle-3.4.1-1.el8.x86_64                                                                                                                   28/238 
  Verifying        : network-scripts-10.00.6-1.el8_2.2.x86_64                                                                                                    29/238 
  Verifying        : network-scripts-team-1.29-1.el8_2.2.x86_64                                                                                                  30/238 
  Verifying        : npth-1.5-4.el8.x86_64                                                                                                                       31/238 
  Verifying        : openssl-pkcs11-0.4.10-2.el8.x86_64                                                                                                          32/238 
  Verifying        : pcre2-10.32-1.el8.x86_64                                                                                                                    33/238 
  Verifying        : platform-python-3.6.8-23.el8.x86_64                                                                                                         34/238 
  Verifying        : platform-python-pip-9.0.3-16.el8.noarch                                                                                                     35/238 
  Verifying        : platform-python-setuptools-39.2.0-5.el8.noarch                                                                                              36/238 
  Verifying        : psmisc-23.1-4.el8.x86_64                                                                                                                    37/238 
  Verifying        : python3-configobj-5.0.6-11.el8.noarch                                                                                                       38/238 
  Verifying        : python3-dbus-1.2.4-15.el8.x86_64                                                                                                            39/238 
  Verifying        : python3-decorator-4.2.1-2.el8.noarch                                                                                                        40/238 
  Verifying        : python3-dnf-4.2.17-7.el8_2.noarch                                                                                                           41/238 
  Verifying        : python3-gobject-base-3.28.3-1.el8.x86_64                                                                                                    42/238 
  Verifying        : python3-gpg-1.10.0-6.el8.0.1.x86_64                                                                                                         43/238 
  Verifying        : python3-hawkey-0.39.1-6.el8_2.x86_64                                                                                                        44/238 
  Verifying        : python3-libcomps-0.1.11-4.el8.x86_64                                                                                                        45/238 
  Verifying        : python3-libdnf-0.39.1-6.el8_2.x86_64                                                                                                        46/238 
  Verifying        : python3-linux-procfs-0.6-7.el8.noarch                                                                                                       47/238 
  Verifying        : python3-perf-4.18.0-193.28.1.el8_2.x86_64                                                                                                   48/238 
  Verifying        : python3-pip-wheel-9.0.3-16.el8.noarch                                                                                                       49/238 
  Verifying        : python3-pyudev-0.21.0-7.el8.noarch                                                                                                          50/238 
  Verifying        : python3-rpm-4.14.2-37.el8.x86_64                                                                                                            51/238 
  Verifying        : python3-schedutils-0.6-6.el8.x86_64                                                                                                         52/238 
  Verifying        : python3-setuptools-wheel-39.2.0-5.el8.noarch                                                                                                53/238 
  Verifying        : python3-six-1.11.0-8.el8.noarch                                                                                                             54/238 
  Verifying        : python3-syspurpose-1.26.20-1.el8_2.x86_64                                                                                                   55/238 
  Verifying        : readonly-root-10.00.6-1.el8_2.2.noarch                                                                                                      56/238 
  Verifying        : rpm-plugin-systemd-inhibit-4.14.2-37.el8.x86_64                                                                                             57/238 
  Verifying        : sqlite-libs-3.26.0-6.el8.x86_64                                                                                                             58/238 
  Verifying        : systemd-container-239-31.el8_2.2.x86_64                                                                                                     59/238 
  Verifying        : systemd-pam-239-31.el8_2.2.x86_64                                                                                                           60/238 
  Verifying        : systemd-udev-239-31.el8_2.2.x86_64                                                                                                          61/238 
  Verifying        : trousers-0.3.14-4.el8.x86_64                                                                                                                62/238 
  Verifying        : trousers-lib-0.3.14-4.el8.x86_64                                                                                                            63/238 
  Verifying        : vim-minimal-2:8.0.1763-13.el8.x86_64                                                                                                        64/238 
  Verifying        : authselect-compat-1.1-2.el8.x86_64                                                                                                          65/238 
  Verifying        : authconfig-6.2.8-30.el7.x86_64                                                                                                              66/238 
  Verifying        : compat-openssl10-1:1.0.2o-3.el8.x86_64                                                                                                      67/238 
  Verifying        : geolite2-city-20180605-1.el8.noarch                                                                                                         68/238 
  Verifying        : geolite2-country-20180605-1.el8.noarch                                                                                                      69/238 
  Verifying        : libmaxminddb-1.2.0-7.el8.x86_64                                                                                                             70/238 
  Verifying        : libxkbcommon-0.9.1-1.el8.x86_64                                                                                                             71/238 
  Verifying        : oddjob-0.34.4-7.el8.x86_64                                                                                                                  72/238 
  Verifying        : oddjob-mkhomedir-0.34.4-7.el8.x86_64                                                                                                        73/238 
  Verifying        : python2-2.7.17-1.module_el8.2.0+381+9a5b3c3b.x86_64                                                                                         74/238 
  Verifying        : python2-libs-2.7.17-1.module_el8.2.0+381+9a5b3c3b.x86_64                                                                                    75/238 
  Verifying        : python2-pip-9.0.3-16.module_el8.2.0+381+9a5b3c3b.noarch                                                                                     76/238 
  Verifying        : python2-pip-wheel-9.0.3-16.module_el8.2.0+381+9a5b3c3b.noarch                                                                               77/238 
  Verifying        : python2-setuptools-39.0.1-11.module_el8.2.0+381+9a5b3c3b.noarch                                                                             78/238 
  Verifying        : python2-setuptools-wheel-39.0.1-11.module_el8.2.0+381+9a5b3c3b.noarch                                                                       79/238 
  Verifying        : python3-unbound-1.7.3-11.el8_2.x86_64                                                                                                       80/238 
  Verifying        : unbound-libs-1.7.3-11.el8_2.x86_64                                                                                                          81/238 
  Verifying        : xkeyboard-config-2.28-1.el8.noarch                                                                                                          82/238 
  Verifying        : bc-1.07.1-5.el8.x86_64                                                                                                                      83/238 
  Verifying        : bc-1.06.95-13.el7.x86_64                                                                                                                    84/238 
  Verifying        : bind-export-libs-32:9.11.13-6.el8_2.1.x86_64                                                                                                85/238 
  Verifying        : bind-export-libs-32:9.11.4-26.P2.el7_9.2.x86_64                                                                                             86/238 
  Verifying        : binutils-2.30-73.el8.x86_64                                                                                                                 87/238 
  Verifying        : binutils-2.27-44.base.el7.x86_64                                                                                                            88/238 
  Verifying        : cryptsetup-libs-2.2.2-1.el8.x86_64                                                                                                          89/238 
  Verifying        : cryptsetup-libs-2.0.3-6.el7.x86_64                                                                                                          90/238 
  Verifying        : dhcp-common-12:4.3.6-40.el8.noarch                                                                                                          91/238 
  Verifying        : dhcp-common-12:4.2.5-82.el7.centos.x86_64                                                                                                   92/238 
  Verifying        : dhcp-libs-12:4.3.6-40.el8.x86_64                                                                                                            93/238 
  Verifying        : dhcp-libs-12:4.2.5-82.el7.centos.x86_64                                                                                                     94/238 
  Verifying        : dnf-4.2.17-7.el8_2.noarch                                                                                                                   95/238 
  Verifying        : dnf-4.0.9.2-1.el7_6.noarch                                                                                                                  96/238 
  Verifying        : dnf-data-4.2.17-7.el8_2.noarch                                                                                                              97/238 
  Verifying        : dnf-data-4.0.9.2-1.el7_6.noarch                                                                                                             98/238 
  Verifying        : gdbm-1:1.18-1.el8.x86_64                                                                                                                    99/238 
  Verifying        : gdbm-1.10-8.el7.x86_64                                                                                                                     100/238 
  Verifying        : gettext-0.19.8.1-17.el8.x86_64                                                                                                             101/238 
  Verifying        : gettext-0.19.8.1-3.el7.x86_64                                                                                                              102/238 
  Verifying        : gettext-libs-0.19.8.1-17.el8.x86_64                                                                                                        103/238 
  Verifying        : gettext-libs-0.19.8.1-3.el7.x86_64                                                                                                         104/238 
  Verifying        : glibc-2.28-101.el8.x86_64                                                                                                                  105/238 
  Verifying        : glibc-2.17-317.el7.x86_64                                                                                                                  106/238 
  Verifying        : glibc-common-2.28-101.el8.x86_64                                                                                                           107/238 
  Verifying        : glibc-common-2.17-317.el7.x86_64                                                                                                           108/238 
  Verifying        : gnupg2-2.2.9-1.el8.x86_64                                                                                                                  109/238 
  Verifying        : gnupg2-2.0.22-5.el7_5.x86_64                                                                                                               110/238 
  Verifying        : gpgme-1.10.0-6.el8.0.1.x86_64                                                                                                              111/238 
  Verifying        : gpgme-1.3.2-5.el7.x86_64                                                                                                                   112/238 
  Verifying        : grep-3.1-6.el8.x86_64                                                                                                                      113/238 
  Verifying        : grep-2.20-3.el7.x86_64                                                                                                                     114/238 
  Verifying        : initscripts-10.00.6-1.el8_2.2.x86_64                                                                                                       115/238 
  Verifying        : initscripts-9.49.53-1.el7_9.1.x86_64                                                                                                       116/238 
  Verifying        : json-c-0.13.1-0.2.el8.x86_64                                                                                                               117/238 
  Verifying        : json-c-0.11-4.el7_0.x86_64                                                                                                                 118/238 
  Verifying        : libblkid-2.32.1-22.el8.x86_64                                                                                                              119/238 
  Verifying        : libblkid-2.23.2-65.el7.x86_64                                                                                                              120/238 
  Verifying        : libcomps-0.1.11-4.el8.x86_64                                                                                                               121/238 
  Verifying        : libcomps-0.1.8-14.el7.x86_64                                                                                                               122/238 
  Verifying        : libdnf-0.39.1-6.el8_2.x86_64                                                                                                               123/238 
  Verifying        : libdnf-0.22.5-2.el7_9.x86_64                                                                                                               124/238 
  Verifying        : python2-hawkey-0.22.5-2.el7_9.x86_64                                                                                                       125/238 
  Verifying        : python2-libdnf-0.22.5-2.el7_9.x86_64                                                                                                       126/238 
  Verifying        : libevent-2.1.8-5.el8.x86_64                                                                                                                127/238 
  Verifying        : libevent-2.0.21-4.el7.x86_64                                                                                                               128/238 
  Verifying        : libgcrypt-1.8.3-4.el8.x86_64                                                                                                               129/238 
  Verifying        : libgcrypt-1.5.3-14.el7.x86_64                                                                                                              130/238 
  Verifying        : libgpg-error-1.31-1.el8.x86_64                                                                                                             131/238 
  Verifying        : libgpg-error-1.12-3.el7.x86_64                                                                                                             132/238 
  Verifying        : libmount-2.32.1-22.el8.x86_64                                                                                                              133/238 
  Verifying        : libmount-2.23.2-65.el7.x86_64                                                                                                              134/238 
  Verifying        : libnfsidmap-1:2.3.3-31.el8.x86_64                                                                                                          135/238 
  Verifying        : libnfsidmap-0.25-19.el7.x86_64                                                                                                             136/238 
  Verifying        : librepo-1.11.0-3.el8_2.x86_64                                                                                                              137/238 
  Verifying        : librepo-1.8.1-8.el7_9.x86_64                                                                                                               138/238 
  Verifying        : libsmartcols-2.32.1-22.el8.x86_64                                                                                                          139/238 
  Verifying        : libsmartcols-2.23.2-65.el7.x86_64                                                                                                          140/238 
  Verifying        : libsolv-0.7.7-1.el8.x86_64                                                                                                                 141/238 
  Verifying        : libsolv-0.6.34-4.el7.x86_64                                                                                                                142/238 
  Verifying        : libstdc++-8.3.1-5.el8.0.2.x86_64                                                                                                           143/238 
  Verifying        : libstdc++-4.8.5-44.el7.x86_64                                                                                                              144/238 
  Verifying        : libtirpc-1.1.4-4.el8.x86_64                                                                                                                145/238 
  Verifying        : libtirpc-0.2.4-0.16.el7.x86_64                                                                                                             146/238 
  Verifying        : libunistring-0.9.9-3.el8.x86_64                                                                                                            147/238 
  Verifying        : libunistring-0.9.3-9.el7.x86_64                                                                                                            148/238 
  Verifying        : libuuid-2.32.1-22.el8.x86_64                                                                                                               149/238 
  Verifying        : libuuid-2.23.2-65.el7.x86_64                                                                                                               150/238 
  Verifying        : libverto-0.3.0-5.el8.x86_64                                                                                                                151/238 
  Verifying        : libverto-0.2.5-4.el7.x86_64                                                                                                                152/238 
  Verifying        : libverto-libevent-0.3.0-5.el8.x86_64                                                                                                       153/238 
  Verifying        : libverto-libevent-0.2.5-4.el7.x86_64                                                                                                       154/238 
  Verifying        : man-db-2.7.6.1-17.el8.x86_64                                                                                                               155/238 
  Verifying        : man-db-2.6.3-11.el7.x86_64                                                                                                                 156/238 
  Verifying        : ncurses-6.1-7.20180224.el8.x86_64                                                                                                          157/238 
  Verifying        : ncurses-5.9-14.20130511.el7_4.x86_64                                                                                                       158/238 
  Verifying        : ncurses-base-6.1-7.20180224.el8.noarch                                                                                                     159/238 
  Verifying        : ncurses-base-5.9-14.20130511.el7_4.noarch                                                                                                  160/238 
  Verifying        : ncurses-libs-6.1-7.20180224.el8.x86_64                                                                                                     161/238 
  Verifying        : ncurses-libs-5.9-14.20130511.el7_4.x86_64                                                                                                  162/238 
  Verifying        : nfs-utils-1:2.3.3-31.el8.x86_64                                                                                                            163/238 
  Verifying        : nfs-utils-1:1.3.0-0.68.el7.x86_64                                                                                                          164/238 
  Verifying        : openssh-8.0p1-4.el8_1.x86_64                                                                                                               165/238 
  Verifying        : openssh-7.4p1-21.el7.x86_64                                                                                                                166/238 
  Verifying        : openssh-clients-8.0p1-4.el8_1.x86_64                                                                                                       167/238 
  Verifying        : openssh-clients-7.4p1-21.el7.x86_64                                                                                                        168/238 
  Verifying        : openssh-server-8.0p1-4.el8_1.x86_64                                                                                                        169/238 
  Verifying        : openssh-server-7.4p1-21.el7.x86_64                                                                                                         170/238 
  Verifying        : openssl-1:1.1.1c-15.el8.x86_64                                                                                                             171/238 
  Verifying        : openssl-1:1.0.2k-19.el7.x86_64                                                                                                             172/238 
  Verifying        : openssl-libs-1:1.1.1c-15.el8.x86_64                                                                                                        173/238 
  Verifying        : openssl-libs-1:1.0.2k-19.el7.x86_64                                                                                                        174/238 
  Verifying        : parted-3.2-38.el8.x86_64                                                                                                                   175/238 
  Verifying        : parted-3.1-32.el7.x86_64                                                                                                                   176/238 
  Verifying        : python3-libs-3.6.8-23.el8.x86_64                                                                                                           177/238 
  Verifying        : python3-libs-3.6.8-18.el7.x86_64                                                                                                           178/238 
  Verifying        : readline-7.0-10.el8.x86_64                                                                                                                 179/238 
  Verifying        : readline-6.2-11.el7.x86_64                                                                                                                 180/238 
  Verifying        : rpcbind-1.2.5-7.el8.x86_64                                                                                                                 181/238 
  Verifying        : rpcbind-0.2.0-49.el7.x86_64                                                                                                                182/238 
  Verifying        : rpm-4.14.2-37.el8.x86_64                                                                                                                   183/238 
  Verifying        : rpm-4.11.3-45.el7.x86_64                                                                                                                   184/238 
  Verifying        : rpm-build-libs-4.14.2-37.el8.x86_64                                                                                                        185/238 
  Verifying        : rpm-build-libs-4.11.3-45.el7.x86_64                                                                                                        186/238 
  Verifying        : rpm-libs-4.14.2-37.el8.x86_64                                                                                                              187/238 
  Verifying        : rpm-libs-4.11.3-45.el7.x86_64                                                                                                              188/238 
  Verifying        : sqlite-3.26.0-6.el8.x86_64                                                                                                                 189/238 
  Verifying        : sqlite-3.7.17-8.el7_7.1.x86_64                                                                                                             190/238 
  Verifying        : sudo-1.8.29-5.el8.x86_64                                                                                                                   191/238 
  Verifying        : sudo-1.8.23-10.el7.x86_64                                                                                                                  192/238 
  Verifying        : systemd-239-31.el8_2.2.x86_64                                                                                                              193/238 
  Verifying        : systemd-219-78.el7_9.2.x86_64                                                                                                              194/238 
  Verifying        : systemd-libs-239-31.el8_2.2.x86_64                                                                                                         195/238 
  Verifying        : systemd-libs-219-78.el7_9.2.x86_64                                                                                                         196/238 
  Verifying        : tuned-2.13.0-6.el8.noarch                                                                                                                  197/238 
  Verifying        : tuned-2.11.0-10.el7.noarch                                                                                                                 198/238 
  Verifying        : util-linux-2.32.1-22.el8.x86_64                                                                                                            199/238 
  Verifying        : util-linux-2.23.2-65.el7.x86_64                                                                                                            200/238 
  Verifying        : which-2.21-12.el8.x86_64                                                                                                                   201/238 
  Verifying        : which-2.20-7.el7.x86_64                                                                                                                    202/238 
  Verifying        : xfsprogs-5.0.0-2.el8.x86_64                                                                                                                203/238 
  Verifying        : xfsprogs-4.5.0-22.el7.x86_64                                                                                                               204/238 
  Verifying        : xz-5.2.4-3.el8.x86_64                                                                                                                      205/238 
  Verifying        : xz-5.2.2-1.el7.x86_64                                                                                                                      206/238 
  Verifying        : xz-libs-5.2.4-3.el8.x86_64                                                                                                                 207/238 
  Verifying        : xz-libs-5.2.2-1.el7.x86_64                                                                                                                 208/238 
  Verifying        : lua-5.3.4-11.el8.x86_64                                                                                                                    209/238 
  Verifying        : lua-5.1.4-15.el7.x86_64                                                                                                                    210/238 
  Verifying        : cloud-init-19.4-7.el7.centos.2.x86_64                                                                                                      211/238 
  Verifying        : deltarpm-3.6-3.el7.x86_64                                                                                                                  212/238 
  Verifying        : grub2-1:2.02-0.86.el7.centos.x86_64                                                                                                        213/238 
  Verifying        : grub2-pc-1:2.02-0.86.el7.centos.x86_64                                                                                                     214/238 
  Verifying        : grub2-tools-1:2.02-0.86.el7.centos.x86_64                                                                                                  215/238 
  Verifying        : grub2-tools-extra-1:2.02-0.86.el7.centos.x86_64                                                                                            216/238 
  Verifying        : libsemanage-python-2.5-14.el7.x86_64                                                                                                       217/238 
  Verifying        : libxml2-python-2.9.1-6.el7.5.x86_64                                                                                                        218/238 
  Verifying        : policycoreutils-python-2.5-34.el7.x86_64                                                                                                   219/238 
  Verifying        : pyserial-2.6-6.el7.noarch                                                                                                                  220/238 
  Verifying        : python-2.7.5-90.el7.x86_64                                                                                                                 221/238 
  Verifying        : python-chardet-2.2.1-3.el7.noarch                                                                                                          222/238 
  Verifying        : python-jsonpatch-1.2-4.el7.noarch                                                                                                          223/238 
  Verifying        : python-jsonpointer-1.9-2.el7.noarch                                                                                                        224/238 
  Verifying        : python-kitchen-1.1.1-5.el7.noarch                                                                                                          225/238 
  Verifying        : python-libs-2.7.5-90.el7.x86_64                                                                                                            226/238 
  Verifying        : python-linux-procfs-0.4.11-4.el7.noarch                                                                                                    227/238 
  Verifying        : python-requests-2.6.0-10.el7.noarch                                                                                                        228/238 
  Verifying        : python-schedutils-0.4-6.el7.x86_64                                                                                                         229/238 
  Verifying        : python-setuptools-0.9.8-7.el7.noarch                                                                                                       230/238 
  Verifying        : python-urlgrabber-3.10-10.el7.noarch                                                                                                       231/238 
  Verifying        : python2-dnf-4.0.9.2-1.el7_6.noarch                                                                                                         232/238 
  Verifying        : python2-libcomps-0.1.8-14.el7.x86_64                                                                                                       233/238 
  Verifying        : python3-3.6.8-18.el7.x86_64                                                                                                                234/238 
  Verifying        : python36-rpm-4.11.3-8.el7.x86_64                                                                                                           235/238 
  Verifying        : pyxattr-0.5.1-5.el7.x86_64                                                                                                                 236/238 
  Verifying        : rpm-python-4.11.3-45.el7.x86_64                                                                                                            237/238 
  Verifying        : systemd-sysv-219-78.el7_9.2.x86_64                                                                                                         238/238 

Upgraded:
  bc-1.07.1-5.el8.x86_64                 bind-export-libs-32:9.11.13-6.el8_2.1.x86_64   binutils-2.30-73.el8.x86_64              cryptsetup-libs-2.2.2-1.el8.x86_64  
  dhcp-common-12:4.3.6-40.el8.noarch     dhcp-libs-12:4.3.6-40.el8.x86_64               dnf-4.2.17-7.el8_2.noarch                dnf-data-4.2.17-7.el8_2.noarch      
  gdbm-1:1.18-1.el8.x86_64               gettext-0.19.8.1-17.el8.x86_64                 gettext-libs-0.19.8.1-17.el8.x86_64      glibc-2.28-101.el8.x86_64           
  glibc-common-2.28-101.el8.x86_64       gnupg2-2.2.9-1.el8.x86_64                      gpgme-1.10.0-6.el8.0.1.x86_64            grep-3.1-6.el8.x86_64               
  initscripts-10.00.6-1.el8_2.2.x86_64   json-c-0.13.1-0.2.el8.x86_64                   libblkid-2.32.1-22.el8.x86_64            libcomps-0.1.11-4.el8.x86_64        
  libdnf-0.39.1-6.el8_2.x86_64           libevent-2.1.8-5.el8.x86_64                    libgcrypt-1.8.3-4.el8.x86_64             libgpg-error-1.31-1.el8.x86_64      
  libmount-2.32.1-22.el8.x86_64          libnfsidmap-1:2.3.3-31.el8.x86_64              librepo-1.11.0-3.el8_2.x86_64            libsmartcols-2.32.1-22.el8.x86_64   
  libsolv-0.7.7-1.el8.x86_64             libstdc++-8.3.1-5.el8.0.2.x86_64               libtirpc-1.1.4-4.el8.x86_64              libunistring-0.9.9-3.el8.x86_64     
  libuuid-2.32.1-22.el8.x86_64           libverto-0.3.0-5.el8.x86_64                    libverto-libevent-0.3.0-5.el8.x86_64     man-db-2.7.6.1-17.el8.x86_64        
  ncurses-6.1-7.20180224.el8.x86_64      ncurses-base-6.1-7.20180224.el8.noarch         ncurses-libs-6.1-7.20180224.el8.x86_64   nfs-utils-1:2.3.3-31.el8.x86_64     
  openssh-8.0p1-4.el8_1.x86_64           openssh-clients-8.0p1-4.el8_1.x86_64           openssh-server-8.0p1-4.el8_1.x86_64      openssl-1:1.1.1c-15.el8.x86_64      
  openssl-libs-1:1.1.1c-15.el8.x86_64    parted-3.2-38.el8.x86_64                       python3-libs-3.6.8-23.el8.x86_64         readline-7.0-10.el8.x86_64          
  rpcbind-1.2.5-7.el8.x86_64             rpm-4.14.2-37.el8.x86_64                       rpm-build-libs-4.14.2-37.el8.x86_64      rpm-libs-4.14.2-37.el8.x86_64       
  sqlite-3.26.0-6.el8.x86_64             sudo-1.8.29-5.el8.x86_64                       systemd-239-31.el8_2.2.x86_64            systemd-libs-239-31.el8_2.2.x86_64  
  tuned-2.13.0-6.el8.noarch              util-linux-2.32.1-22.el8.x86_64                which-2.21-12.el8.x86_64                 xfsprogs-5.0.0-2.el8.x86_64         
  xz-5.2.4-3.el8.x86_64                  xz-libs-5.2.4-3.el8.x86_64                     lua-5.3.4-11.el8.x86_64                 

Installed:
  gnupg2-smime-2.2.9-1.el8.x86_64                                                 network-scripts-team-1.29-1.el8_2.2.x86_64                                           
  openssl-pkcs11-0.4.10-2.el8.x86_64                                              platform-python-pip-9.0.3-16.el8.noarch                                              
  rpm-plugin-systemd-inhibit-4.14.2-37.el8.x86_64                                 trousers-0.3.14-4.el8.x86_64                                                         
  geolite2-city-20180605-1.el8.noarch                                             geolite2-country-20180605-1.el8.noarch                                               
  libmaxminddb-1.2.0-7.el8.x86_64                                                 libxkbcommon-0.9.1-1.el8.x86_64                                                      
  oddjob-mkhomedir-0.34.4-7.el8.x86_64                                            python2-pip-9.0.3-16.module_el8.2.0+381+9a5b3c3b.noarch                              
  python2-setuptools-39.0.1-11.module_el8.2.0+381+9a5b3c3b.noarch                 python3-unbound-1.7.3-11.el8_2.x86_64                                                
  authselect-1.1-2.el8.x86_64                                                     authselect-libs-1.1-2.el8.x86_64                                                     
  centos-obsolete-packages-8-4.noarch                                             crypto-policies-20191128-2.git23e1bf1.el8.noarch                                     
  dhcp-client-12:4.3.6-40.el8.x86_64                                              gdbm-libs-1:1.18-1.el8.x86_64                                                        
  glibc-all-langpacks-2.28-101.el8.x86_64                                         gnutls-3.6.8-11.el8_2.x86_64                                                         
  hdparm-9.54-2.el8.x86_64                                                        ima-evm-utils-1.1-5.el8.x86_64                                                       
  ipcalc-0.2.4-4.el8.x86_64                                                       iptables-libs-1.8.4-10.el8_2.1.x86_64                                                
  libarchive-3.3.2-8.el8_1.x86_64                                                 libfdisk-2.32.1-22.el8.x86_64                                                        
  libidn2-2.2.0-1.el8.x86_64                                                      libksba-1.3.5-7.el8.x86_64                                                           
  libnsl-2.28-101.el8.x86_64                                                      libnsl2-1.2.0-2.20180605git4a062cf.el8.x86_64                                        
  libpcap-14:1.9.0-3.el8.x86_64                                                   libusbx-1.0.22-1.el8.x86_64                                                          
  libxcrypt-4.1.1-4.el8.x86_64                                                    libzstd-1.4.2-2.el8.x86_64                                                           
  lua-libs-5.3.4-11.el8.x86_64                                                    ncurses-compat-libs-6.1-7.20180224.el8.x86_64                                        
  netconsole-service-10.00.6-1.el8_2.2.noarch                                     nettle-3.4.1-1.el8.x86_64                                                            
  network-scripts-10.00.6-1.el8_2.2.x86_64                                        npth-1.5-4.el8.x86_64                                                                
  pcre2-10.32-1.el8.x86_64                                                        platform-python-3.6.8-23.el8.x86_64                                                  
  platform-python-setuptools-39.2.0-5.el8.noarch                                  psmisc-23.1-4.el8.x86_64                                                             
  python3-configobj-5.0.6-11.el8.noarch                                           python3-dbus-1.2.4-15.el8.x86_64                                                     
  python3-decorator-4.2.1-2.el8.noarch                                            python3-dnf-4.2.17-7.el8_2.noarch                                                    
  python3-gobject-base-3.28.3-1.el8.x86_64                                        python3-gpg-1.10.0-6.el8.0.1.x86_64                                                  
  python3-hawkey-0.39.1-6.el8_2.x86_64                                            python3-libcomps-0.1.11-4.el8.x86_64                                                 
  python3-libdnf-0.39.1-6.el8_2.x86_64                                            python3-linux-procfs-0.6-7.el8.noarch                                                
  python3-perf-4.18.0-193.28.1.el8_2.x86_64                                       python3-pip-wheel-9.0.3-16.el8.noarch                                                
  python3-pyudev-0.21.0-7.el8.noarch                                              python3-rpm-4.14.2-37.el8.x86_64                                                     
  python3-schedutils-0.6-6.el8.x86_64                                             python3-setuptools-wheel-39.2.0-5.el8.noarch                                         
  python3-six-1.11.0-8.el8.noarch                                                 python3-syspurpose-1.26.20-1.el8_2.x86_64                                            
  readonly-root-10.00.6-1.el8_2.2.noarch                                          sqlite-libs-3.26.0-6.el8.x86_64                                                      
  systemd-container-239-31.el8_2.2.x86_64                                         systemd-pam-239-31.el8_2.2.x86_64                                                    
  systemd-udev-239-31.el8_2.2.x86_64                                              trousers-lib-0.3.14-4.el8.x86_64                                                     
  vim-minimal-2:8.0.1763-13.el8.x86_64                                            authselect-compat-1.1-2.el8.x86_64                                                   
  compat-openssl10-1:1.0.2o-3.el8.x86_64                                          oddjob-0.34.4-7.el8.x86_64                                                           
  python2-2.7.17-1.module_el8.2.0+381+9a5b3c3b.x86_64                             python2-libs-2.7.17-1.module_el8.2.0+381+9a5b3c3b.x86_64                             
  python2-pip-wheel-9.0.3-16.module_el8.2.0+381+9a5b3c3b.noarch                   python2-setuptools-wheel-39.0.1-11.module_el8.2.0+381+9a5b3c3b.noarch                
  unbound-libs-1.7.3-11.el8_2.x86_64                                              xkeyboard-config-2.28-1.el8.noarch                                                   

Removed:
  cloud-init-19.4-7.el7.centos.2.x86_64     deltarpm-3.6-3.el7.x86_64                       grub2-1:2.02-0.86.el7.centos.x86_64  grub2-pc-1:2.02-0.86.el7.centos.x86_64
  grub2-tools-1:2.02-0.86.el7.centos.x86_64 grub2-tools-extra-1:2.02-0.86.el7.centos.x86_64 libsemanage-python-2.5-14.el7.x86_64 libxml2-python-2.9.1-6.el7.5.x86_64   
  policycoreutils-python-2.5-34.el7.x86_64  pyserial-2.6-6.el7.noarch                       python-2.7.5-90.el7.x86_64           python-chardet-2.2.1-3.el7.noarch     
  python-jsonpatch-1.2-4.el7.noarch         python-jsonpointer-1.9-2.el7.noarch             python-kitchen-1.1.1-5.el7.noarch    python-libs-2.7.5-90.el7.x86_64       
  python-linux-procfs-0.4.11-4.el7.noarch   python-requests-2.6.0-10.el7.noarch             python-schedutils-0.4-6.el7.x86_64   python-setuptools-0.9.8-7.el7.noarch  
  python-urlgrabber-3.10-10.el7.noarch      python2-dnf-4.0.9.2-1.el7_6.noarch              python2-libcomps-0.1.8-14.el7.x86_64 python3-3.6.8-18.el7.x86_64           
  python36-rpm-4.11.3-8.el7.x86_64          pyxattr-0.5.1-5.el7.x86_64                      rpm-python-4.11.3-45.el7.x86_64      systemd-sysv-219-78.el7_9.2.x86_64    

Complete!
```

Realizaremos las instalacion minimal del sistema:
```shell
 [centos@quijote ~]$ sudo dnf -y groupupdate "Core" "Minimal Install" --allowerasing --skip-broken
```
Al realizar el comando la maquina se paro al hacer running transantion, no puedo acceder a Horizon para verificar mi maquina cuando vuelva a estar operativo procedere a terminar la practica.

Basicamente quedaba reiniciarla y una vez echo eso comprobar el resultado que deberia ser su correcta actualización.