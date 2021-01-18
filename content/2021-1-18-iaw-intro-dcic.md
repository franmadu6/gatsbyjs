---
date: 2021-01-18
title: "Práctica: Introducción a la integración continua"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - IAW
tags:
    - Integración continua
    - Despliegue continuo 
---

## Tarea: Integración continúa de aplicación django (Test + Deploy)

Vamos a trabajar con el repositorio de la aplicación django_tutorial. Esta aplicación tiene definidas una serie de test, que podemos estudiar en el fichero tests.py del directorio polls.

Para ejecutar las pruebas unitarias, ejecutamos la instrucción python3 manage.py test.

### Estudia las distintas pruebas que se han realizado, y modifica el código de la aplicación (debes modificar el fichero views.py o los templates, no debes cambiar el fichero tests.py para que al menos una de ella no se ejecute de manera exitosa.

A continuación vamos a configurar la integración continúa para que cada vez que hagamos un commit se haga la ejecución de test en la herramienta de CI/CD que haya elegido.

### Crea el pipeline en el sistema de CI/CD para que pase automáticamente los tests. Muestra el fichero de configuración y una captura de pantalla con un resultado exitoso de la IC y otro con un error.

A continuación vamos a realziar el despliegue coontinuo en un servicio de hosting, por ejemplo heroku.

### Entrega un breve descripción de los pasos más importantes para realizar el despliegue desde el sistema de CI/CS y entrega una prueba de funcionamiento donde se compruebe cómo se hace el despliegue automático.
