---
date: 2021-02-09
title: "Instalación y configuración básica de VMWare ESXi"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - HLC
tags:
    - VMWare ESXi
    - Instalación
    - Servidores
---


## Utiliza el servidor físico que se te haya asignado e instala la versión adecuada del sistema de virtualización VMWare ESXi (ten en cuenta que recibe diferentes denominaciones comerciales, pero nos referimos al sistema de virtualización de VMWare que proporciona virtualización de alto rendimiento mediante la técnica de la paravirtualización).

## Realiza la configuración del servicio que permita su gestión remota desde un equipo cliente e instala en tu equipo la aplicación cliente que permita gestionar remotamente el hipervisor.

## Instala una máquina virtual que tenga acceso a Internet. La corrección consistirá en comprobar el funcionamiento de dicha máquina virtual.

Nota: La fecha de comienzo y finalización de esta tarea irá variando en función de la disponibilidad de servidores físicos.
<hr>

Para comenzar nos desplazaremos a los servidores del cloud una vez asignada nuestra máquina, guardaremos una copia de VMWare en un usb y procederemos a su instalación.

(**IMPORTANTE**:Deshabilitar el modulo IPMI para una instalación mucho mas rapida.)
Una vez realizada la instalación configuraremos un usuario para poder acceder vía navegador.

Crearemos un host en este caso patricio.gonzalonazareno.org
![PracticaImg](images/hlc/vmware.png "Prueba de acceso")
![PracticaImg](images/hlc/vmware-host.png "host")

Para crear una nueva máquina deberemos antes crear un volumen nuevo.
![PracticaImg](images/hlc/volumen-vmware.png "creación de volumen")

Procederemos a la instalación de una nueva máquina le añadiremos un disco con debian10.
![PracticaImg](images/hlc/vmware-esponja.png "instalación del sistema")

Encenderemos la máquina.
![PracticaImg](images/hlc/vmware-esponja2.png "on sistema")

Nos descargaremos el soporte para visualizar VMWare desde nuestro ordenador
![PracticaImg](images/hlc/instalacion.PNG "operativo")

Nos descargamos y habilitamos el servidor de ssh.
![PracticaImg](images/hlc/terminal.PNG "operativo")

¡Listo! Ya tenemos puesta a punto nuestra maquija en VMWare.
![PracticaImg](images/hlc/esponja-terminal-vmware.png "operativo")

Prueba de ping para comprobar la conexión.
![PracticaImg](images/hlc/vmware-ping.png "operativo")