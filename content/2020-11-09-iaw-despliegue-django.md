---
date: 2020-11-09
title: "Despliegue de aplicaciones python "
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - IAW
tags:
    - Django
---

## Tarea 1: Entorno de desarrollo
Vamos a desarrollar la aplicación del tutorial de django 3.1. Vamos a configurar tu equipo como entorno de desarrollo para trabajar con la aplicación, para ello:

* Realiza un fork del repositorio de GitHub: https://github.com/josedom24/django_tutorial.

Realizamos el fork y añadimos el repositorio a nuestros repositorios, luego lo clonamos a nuestra maquina.
```shell
fran@debian:~/GitHub/django_tutorial$ ls
django_tutorial  manage.py  polls  README.md  requirements.txt
```

* Crea un entorno virtual de python3 e instala las dependencias necesarias para que funcione el proyecto (fichero requirements.txt).

```shell
fran@debian:~/GitHub/django_tutorial$ sudo apt install python3-venv
#creación del entorno
fran@debian:~/GitHub/django_tutorial$ python3 -m venv django
#activación del entorno
fran@debian:~/GitHub/django_tutorial$ source django/bin/activate
(django) fran@debian:~/GitHub/django_tutorial$ 
#instalación del paquete equirements.txt
(django) fran@debian:~/GitHub/django_tutorial$ pip install -r requirements.txt
Collecting asgiref==3.3.0 (from -r requirements.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/c0/e8/578887011652048c2d273bf98839a11020891917f3aa638a0bc9ac04d653/asgiref-3.3.0-py3-none-any.whl
Collecting Django==3.1.3 (from -r requirements.txt (line 2))
  Downloading https://files.pythonhosted.org/packages/7f/17/16267e782a30ea2ce08a9a452c1db285afb0ff226cfe3753f484d3d65662/Django-3.1.3-py3-none-any.whl (7.8MB)
    100% |████████████████████████████████| 7.8MB 241kB/s 
Collecting pytz==2020.4 (from -r requirements.txt (line 3))
  Downloading https://files.pythonhosted.org/packages/12/f8/ff09af6ff61a3efaad5f61ba5facdf17e7722c4393f7d8a66674d2dbd29f/pytz-2020.4-py2.py3-none-any.whl (509kB)
    100% |████████████████████████████████| 512kB 2.1MB/s 
Collecting sqlparse==0.4.1 (from -r requirements.txt (line 4))
  Downloading https://files.pythonhosted.org/packages/14/05/6e8eb62ca685b10e34051a80d7ea94b7137369d8c0be5c3b9d9b6e3f5dae/sqlparse-0.4.1-py3-none-any.whl (42kB)
    100% |████████████████████████████████| 51kB 4.9MB/s 
Installing collected packages: asgiref, sqlparse, pytz, Django
Successfully installed Django-3.1.3 asgiref-3.3.0 pytz-2020.4 sqlparse-0.4.1
```

* Comprueba que vamos a trabajar con una base de datos sqlite (django_tutorial/settings.py). ¿Cómo se llama la base de datos que vamos a crear?


```shell

```

* Crea la base de datos: python3 manage.py migrate. A partir del modelo de datos se crean las tablas de la base de datos.

* Crea un usuario administrador: python3 manage.py createsuperuser.

* Ejecuta el servidor web de desarrollo y entra en la zona de administración (\admin) para comprobar que los datos se han añadido correctamente.

* Crea dos preguntas, con posibles respuestas.

* Comprueba en el navegador que la aplicación está funcionando, accede a la url \polls.

```shell

```

**En este momento, muestra al profesor la aplicación funcionando. Entrega una documentación resumida donde expliques los pasos fundamentales para realizar esta tarea. (2 puntos)**




## Tarea 2: Entorno de producción
Vamos a realizar el despliegue de nuestra aplicación en un entorno de producción, para ello vamos a utilizar una instancia del cloud, sigue los siguientes pasos:

* Instala en el servidor los servicios necesarios (apache2). Instala el módulo de apache2 para ejecutar código python.
* Clona el repositorio en el DocumentRoot de tu virtualhost.
* Crea un entorno virtual e instala las dependencias de tu aplicación.
* Instala el módulo que permite que python trabaje con mysql:

      $ apt-get install python3-mysqldb

    Y en el entorno virtual:

      (env)$ pip install mysql-connector-python

*  Crea una base de datos y un usuario en mysql.

* Configura la aplicación para trabajar con mysql, para ello modifica la configuración de la base de datos en el archivo settings.py:

      DATABASES = {
          'default': {
              'ENGINE': 'mysql.connector.django',
              'NAME': 'myproject',
              'USER': 'myprojectuser',
              'PASSWORD': 'password',
              'HOST': 'localhost',
              'PORT': '',
          }
      }

* Como en la tarea 1, realiza la migración de la base de datos que creará la estructura de datos necesrias. comprueba en mariadb que la base de datos y las tablas se han creado.
* Crea un usuario administrador: python3 manage.py createsuperuser.
* Configura un virtualhost en apache2 con la configuración adecuada para que funcione la aplicación. El punto de entrada de nuestro servidor será django_tutorial/django_tutorial/wsgi.py. Puedes guiarte por el Ejercicio: Desplegando aplicaciones flask, por la documentación de django: How to use Django with Apache and mod_wsgi,…
* Debes asegurarte que el contenido estático se está sirviendo: ¿Se muestra la imagen de fondo de la aplicación? ¿Se ve de forma adecuada la hoja de estilo de la zona de administración?. Para arreglarlo puedes encontrar documentación en How to use Django with Apache and mod_wsgi.
* Desactiva en la configuración (fichero settings.py) el modo debug a False. Para que los errores de ejecución no den información sensible de la aplicación.
* Muestra la página funcionando.

**En este momento, muestra al profesor la aplicación funcionando. Entrega una documentación resumida donde expliques los pasos fundamentales para realizar esta tarea. (4 puntos)**

## Tarea 3: Modificación de nuestra aplicación

Vamos a realizar cambios en el entorno de desarrollo y posteriormente vamos a subirlas a producción. Vamos a realizar tres modificaciones (entrega una captura de pantalla donde se ven cada una de ellas). Recuerda que primero lo haces en el entrono de desarrollo, y luego tendrás que llevar los cambios a producción:

* Modifica la página inicial donde se ven las encuestas para que aparezca tu nombre: Para ello modifica el archivo django_tutorial/polls/templates/polls/index.html.
    Modifica la imagen de fondo que se ve la aplicación.

* Vamos a crear una nueva tabla en la base de datos, para ello sigue los siguientes pasos:

    * Añade un nuevo modelo al fichero polls/models.py:

        
          class Categoria(models.Model):	
          	Abr = models.CharField(max_length=4)
          	Nombre = models.CharField(max_length=50)

          	def __str__(self):
          		return self.Abr+" - "+self.Nombre 		
        
    *  Crea una nueva migración: python3 manage.py makemigrations.
        Y realiza la migración: python3 manage.py migrate

    *  Añade el nuevo modelo al sitio de administración de django:

    *  Para ello cambia la siguiente línea en el fichero polls/admin.py:
        
           from .models import Choice, Question
        
        Por esta otra:
        
           from .models import Choice, Question, Categoria
        
        Y añade al final la siguiente línea:
        
           admin.site.register(Categoria)
        
    *  Despliega el cambio producido al crear la nueva tabla en el entorno de producción.

**Explica los cambios que has realizado en el entorno de desarrollo y cómo lo has desplegado en producción para cada una de las modificaciones (4 puntos).**
