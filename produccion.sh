#!/bin/bash

#Piensa algún método (script, scp, rsync, git,…) que te permita automatizar la generación de la página (integración continua) 
#y el despliegue automático de la página en el entorno de producción, después de realizar un cambio de la página en el entorno de desarrollo. 
#Muestra al profesor un ejemplo de como al modificar la página se realiza la puesta en producción de forma automática. (3 puntos)

echo '######################-M A R K D O W N     G E N E R A T O R-############################'
echo 'Scrip de Automatización de ficheros, Ejecutelo en Administrador para no tener posibles fallos.'
#año-mes-dia actuales:
time=$(date +%Y-%m-%d)
echo "Nombre de la publicación,(cambia los espacios por '-'):"
read nom

#Creo plantilla por defecto para rellenar
echo "---
date: $time
title: "'"'"$nom"'"'"
cover: "'"'"https://img.utdstc.com/icons/brackets-.png:225"'"'"
categories: 
    - Escribe aqui la categoria
tags:
    - Escribe aqui el tag
---


#Titulo
##Titulo2

parrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafo

parrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafoparrafo

1. lista1
2. lista2
3. lista3
4. lista4
5. lista5

enlaces => 
-[Todo lo que necesitas saber de Brackets](https://beatrizruizcorvillo.es/brackets-editor-html/)  

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