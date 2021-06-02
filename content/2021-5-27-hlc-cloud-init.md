---
date: 2021-5-27
title: "Utilización de cloud-init"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - HLC
tags:
    - Cloud-init
    - OpenStack
---

![PracticaImg](images/hlc/cloud-init.svg "cloud init logo")

### cloud-init se define como el estándar para personalizar instancias cloud. Las imágenes para las instancias cloud empiezan siendo idénticas entre sí, al ser clones. Es la información proporcionada por el usuario lo que le da a la instancia su personalidad y cloud-init es la herramienta que aplica esta configuración a las instancias de forma automática.

### cloud-init fue desarrollado inicialmente por Canonical para las imágenes cloud de Ubuntu usadas por AWS. Desde entonces, la aplicación ha evolucionado y puede ser usada en otras muchas distribuciones y en otros entornos cloud (y no cloud).

<hr>

## Elige una instancia del escenario de OpenStack y vuelve a crearla utilizando el mismo volumen para el sistema raíz, pero realizando toda la configuración posible con cloud-init, de manera que la instancia permanezca bien configurada aunque se reinicie.
* Sube a la tarea el fichero **cloud-config** utilizado.

habilitaremos el servidor dhcp de la subred
![PracticaImg](images/hlc/subred-cloud-init.png "subred-cloud-init")


```shell
root@debian:/home/fran/Documentos# echo "export OS_VOLUME_API_VERSION=2" >> Proyecto\ de\ francisco.madu-openrc.sh 
```

