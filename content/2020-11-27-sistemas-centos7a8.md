---
date: 2020-11-27
title: "Actualización de quijote a CentOS8"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - ASO
tags:
    - OpenStack
    - CentOS
    - Actualización
---



## Actualiza la instancia quijote a CentOS 8 garantizando que todos los servicios previos continúen funcionando y detalla en la tarea los aspectos más relevantes.

* En el caso de que la instancia no sea recuperable en algún punto, se tiene que volver a crear una instancia de CentOS 7 y realizar la actualización de nuevo. Lo recomendable en este caso sería crear una instantánea de volumen antes de comenzar y en el caso de tener un error irrecuperable, crear un nuevo volumen a partir de la instantánea, eliminar la instancia quijote y crear una nueva con el nuevo volumen. Una vez arrancada la nueva instancia se puede eliminar el antiguo volumen y las instantáneas asociadas.

* Nota: Aunque aparezca una advertencia de que se puede corromper el volumen al crear una instantánea cuando está en uso, se supone que LVM (el sistema sobre el que se está usando los volúmenes en este caso) soporta la creación de instantáneas en caliente (se supone ;) )

El primer paso que debemos dar es comprobar los repositorios epel de nuestra maquina.
```shell
yum install epel-release -y
```

Instalamos las herramientas yum-utils.
```shell
yum install yum-utils
```

Instalamos rpmconf, lo usaremos para verificar confilctos en ficheros de configuración.
```shell
yum install rpmconf
```

Si queremos instalar la nueva versión del fichero de configuración.
```shell
rpmconf -a
```

Limpiamos los paquetes no necesarios:
```shell
package-cleanup --leaves
package-cleanup --orphans
```

Instalamos el gestor de paquetes **dnf**.
```shell
yum install dnf
```

Los dos gestores de paquetes pueden convivir, pero es mejor que nos quedemos solo con dnf (y eliminamos yum, las dependencias y su directorio):
```shell
dnf -y remove yum yum-metadata-parser
rm -Rf /etc/yum
```

Comenzamos con la actualización de versión, de CentOS7 a CentOS8 y resolvemos los problemas con los paquetes al actualizar a CentOS8.
```shell
dnf upgrade
```

si tenemos errores del estilo: "el archivo *** entra en conflicto con el archivo del paquete ***".

podemos intentar la actualización con la opción –allowerasing, que sirve para reemplazar automáticamente los paquetes con conflictos:
```shell
dnf upgrade --best --allowerasing
```

o usando la opción –skip-broken para eliminar los paquetes problemáticos:
```shell
dnf upgrade --best --allowerasing --skip-broken
```

Si tenemos algun problema con dependencias de algun paquete las borramos manualmente y (ej:dnf remove python3) y volvemos a upgradear con dnf.

A continuación ya podemos instalar el paquete de lanzamiento de Centos8:
```shell
dnf install http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-linux-repos-8-2.el8.noarch.rpm http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-linux-release-8.3-1.2011.el8.noarch.rpm http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-gpg-keys-8-2.el8.noarch.rpm
```

Actualizamos el repositorio EPEL.
```shell
dnf -y upgrade https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
```

Eliminamos los ficheros temporales.
```shell
dnf clean all
```

<hr>

**Eliminamos el viejo kernel para CentOS7 e instalaremos el nuevo kernel para CentOS8**

y ahora eliminamos el núcleo antiguo del kernel de CentOS 7 (si en este paso tenemos errores, realmente seguirá instalado el kernel de centos 7 y no habremos instalado el kernel de centos 8):
```shell
rpm -e `rpm -q kernel`
```

Eliminamos paquetes conflictivos (como las herramientas systemv):
```shell
rpm -e --nodeps sysvinit-tools
```

Si recibimos errores al ejecutar el comando anterior para eliminar el kernel :
```shell
rpm -e `rpm -q kernel`
```

comprobamos si seguimos teniendo errores y conflictos en paquetes; si es así, procuraremos eliminarlos para evitar los problemas (aunque en algunos casos esto es una solución muy arriesgada, sobre todo en servidores en producción).

Otra opción es intentar eliminar el kernel viejo así:
```shell
dnf remove --oldinstallonly --setopt installonly_limit=1 kernel
```

o simplemente así:
```shell
dnf remove kernel
```

<hr>

**Comenzamos la actualización a Centos8**

Lanzamos actualización del sistema a Centos8:
```shell
dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync
```

Si nos encontramos con algunos errores tambien podemos ejecutar:
```shell
dnf -y --releasever=8 --allowerasing --skip-broken --setopt=deltarpm=false distro-sync
```

<hr>

**Instalamos el nuevo kernel para Centos8**

Ejecutamos instalación del kernel
```shell
dnf -y install kernel-core
```

Aunque puede no ser necesario, si queremos estar seguros de que está instalado de forma correcta, primero lo desinstalamos y lo volvemos a instalar
```shell
rpm -e kernel-core
dnf -y install kernel-core
```

Si nuevamente tenemos problemas ejecutaremos:
```shell
dnf -y install kernel-core --best --allowerasing --skip-broken
```

Si no hemos hemos ejecutado los comandos y no hemos tenido mas problemas daremos por hecho que el kernel que tenemos ahora es de Centos8.

<hr>

**Instalamos el paquete minimal de CentOS8 y actualizamos grupos**
```shell
dnf -y groupupdate "Core" "Minimal Install"
```

Si tuvimos problemas:
```shell
dnf -y groupupdate "Core" "Minimal Install" --allowerasing --skip-broken
```

Si tenemos problemas con los paquetes de yum en este punto deberemos volver atras, en la parte donde borramos **yum**. Al borrarlo este error desaparecerá.

<hr>

**Comprobación de que Centos8 y su kernel están instalados correctamente**

```shell
[centos@quijote ~]$ cat /etc/os-release
NAME="CentOS Linux"
VERSION="8"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="8"
PLATFORM_ID="platform:el8"
PRETTY_NAME="CentOS Linux 8"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:8"
HOME_URL="https://centos.org/"
BUG_REPORT_URL="https://bugs.centos.org/"
CENTOS_MANTISBT_PROJECT="CentOS-8"
CENTOS_MANTISBT_PROJECT_VERSION="8"

[centos@quijote ~]$ cat /etc/redhat-release
CentOS Linux release 8.3.2011

[centos@quijote ~]$ uname -r
4.18.0-240.10.1.el8_3.x86_64
```

¡Listo! ya tenemos upgradeada nuestra maquina a **Centos8**.