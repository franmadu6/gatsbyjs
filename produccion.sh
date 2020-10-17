#!/bin/bash

#Piensa algún método (script, scp, rsync, git,…) que te permita automatizar la generación de la página (integración continua) 
#y el despliegue automático de la página en el entorno de producción, después de realizar un cambio de la página en el entorno de desarrollo. 
#Muestra al profesor un ejemplo de como al modificar la página se realiza la puesta en producción de forma automática. (3 puntos)

echo '##################################-G A T S B Y J S-#############################################'
echo 'Scrip de Automatización de ficheros, Ejecutelo en Administrador para no tener posibles fallos.'
#año-mes-dia actuales:
time=$(date +%Y-%m-%d)
echo "Nombre de la publicación,(cambia los espacios por '-'):"
read nom

#Creo plantilla por defecto para rellenar
echo "---
date: $time
title: " $nom "
cover: "Añade un cover o borra la linea si no quieres poner ninguno"
categories: 
    - Escribe aqui la categoria
tags:
    - Escribe aqui el tag
---


## Titulo

Comienza a escribir tu publicación
" > content/$time-$nom.md

#Escribo el contenido de mi publicación
nano content/$time-$nom.md

#Subir los archivos a Github
sudo git add .
sudo git commit -m "Publicación añadida por el Script de Producción"
sudo git push

#Cuando se ejecute npm run deploy todo el contenido de la public carpeta se moverá a la rama master de mi repositorio .
npm run deploy