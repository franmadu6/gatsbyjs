---
date: 2020-11-15
title: "Compilación de un kérnel linux a medida"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - ASO
tags:
    - Kernel
    - Linux 
---

Al ser linux un kérnel libre, es posible descargar el código fuente, configurarlo y comprimirlo. Además, esta tarea a priori compleja, es más sencilla de lo que parece gracias a las herramientas disponibles.

En esta tarea debes tratar de compilar un kérnel completamente funcional que reconozca todo el hardware básico de tu equipo y que sea a la vez lo más pequeño posible, es decir que incluya un vmlinuz lo más pequeño posible y que incorpore sólo los módulos imprescindibles. Para ello utiliza el método explicado en clase y entrega finalmente el fichero deb con el kérnel compilado por ti.

El hardware básico incluye como mínimo el teclado, la interfaz de red y la consola gráfica (texto).

### Pasos a seguir
Con el fin de compilar nuestro kernel de la mejor manera posible dividiremos las tareas en pasos:

1. Instalamos la paqueteria correspondiente, en este caso linux-source al ser un metapaquete si instalará la version indicada para nuestro linux.
```shell
fran@debian:~$ sudo apt-get install linux-source
```

2. Creacion del entorno:  
Crearemos una carpeta a donde trabajaremos con la compilación.
```shell
/home/fran/kernel/comp/
```

3. Descomprimimos el codigo fuente del kernel:
```shell

```