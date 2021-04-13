---
date: 2021-01-28
title: "[IAW] - Instalación de aplicación web python en OpenStack"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - IAW
tags:
    - CMS
    - PYTHON
    - OpenStack
---

![PracticaImg](images/iaw/mezzanine.png "mezzanine logo")

Instalación de aplicación web python

En esta tarea vamos a desplegar un CMS python. Tienes que realizar la instalación de un CMS python basado en django (puedes encontrar varios en el siguiente enlace: https://djangopackages.org/grids/g/cms/


* Instala el CMS en el entorno de desarrollo. Debes utilizar un entorno virtual.

* Personaliza la página (cambia el nombre al blog y pon tu nombre) y añade contenido (algún artículo con alguna imagen).

* Guarda los ficheros generados durante la instalación en un repositorio github. Guarda también en ese repositorio la copia de seguridad de la bese de datos. Te en cuenta que en el entorno de desarrolla vas a tener una base de datos sqlite, y en el entorno de producción una mariadb, por lo tanto es recomendable para hacer la copia de seguridad y recuperarla los comandos: python manage.py dumpdata y python manage.py loaddata, para más información: https://coderwall.com/p/mvsoyg/django-dumpdata-and-loaddata

* Realiza el despliegue de la aplicación en tu entorno de producción (servidor web y servidor de base de datos en el cloud). Utiliza un entorno virtual. Como servidor de aplicación puedes usar gunicorn o uwsgi (crea una unidad systemd para gestionar este servicio). El contenido estático debe servirlo el servidor web. La aplicación será accesible en la url python.tunombre.gonzalonazareno.org.

