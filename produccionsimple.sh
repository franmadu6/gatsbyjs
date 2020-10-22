#!/bin/bash

#Subir los archivos a Github
sudo git add .
sudo git commit -m "Publicación añadida por el Script de Producción"
sudo git push

#Cuando se ejecute npm run deploy todo el contenido de la public carpeta se moverá a la rama master de mi repositorio .
npm run deploy