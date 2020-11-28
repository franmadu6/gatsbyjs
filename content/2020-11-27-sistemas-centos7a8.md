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


