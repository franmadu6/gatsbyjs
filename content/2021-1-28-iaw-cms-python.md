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

<hr>

Crearemos un entorno virtual donde instalaremos **Mezzanine**.
```shell
fran@debian:~/.virtualenvs$ python3 -m venv despliegue
fran@debian:~/.virtualenvs$ source despliegue/bin/activate
(despliegue) fran@debian:~/.virtualenvs$ 
```

Instalamos **Mezzanine** haciendo uso de pip y crearemos una nueva carpeta que llamaremos cms(da igual el nombre).
```shell
(despliegue) fran@debian:~/GitHub$ pip install mezzanine
(despliegue) fran@debian:~/GitHub$ mezzanine-project cms
(despliegue) fran@debian:~/GitHub$ tree cms
(despliegue) fran@debian:~/GitHub$ tree cms
cms
├── cms
│   ├── __init__.py
│   ├── local_settings.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── deploy
│   ├── crontab.template
│   ├── gunicorn.conf.py.template
│   ├── local_settings.py.template
│   ├── nginx.conf.template
│   └── supervisor.conf.template
├── fabfile.py
├── manage.py
└── requirements.txt

2 directories, 13 files
```

Modificaremos el fichero cms/settings.py para modificar la base de datos ya que estamos en fase de desarrollo.
```shell
(despliegue) fran@debian:~/GitHub/cms$ nano cms/settings.py
DATABASES = {
    "default": {
        # Add "postgresql_psycopg2", "mysql", "sqlite3" or "oracle".
        "ENGINE": "django.db.backends.sqlite3",
        # DB name or path to database file if using sqlite3.
        "NAME": "",
        # Not used with sqlite3.
        "USER": "",
        # Not used with sqlite3.
        "PASSWORD": "",
        # Set to empty string for localhost. Not used with sqlite3.
        "HOST": "",
        # Set to empty string for default. Not used with sqlite3.
        "PORT": "",
    }
}
```

Haremos una migración para generar tablas en la base de datos.
```shell
(despliegue) fran@debian:~/GitHub/cms$ python3 manage.py migrate
Operations to perform:
  Apply all migrations: admin, auth, blog, conf, contenttypes, core, django_comments, forms, galleries, generic, pages, redirects, sessions, sites, twitter
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying sites.0001_initial... OK
  Applying blog.0001_initial... OK
  Applying blog.0002_auto_20150527_1555... OK
  Applying blog.0003_auto_20170411_0504... OK
  Applying conf.0001_initial... OK
  Applying core.0001_initial... OK
  Applying core.0002_auto_20150414_2140... OK
  Applying django_comments.0001_initial... OK
  Applying django_comments.0002_update_user_email_field_length... OK
  Applying django_comments.0003_add_submit_date_index... OK
  Applying django_comments.0004_add_object_pk_is_removed_index... OK
  Applying pages.0001_initial... OK
  Applying forms.0001_initial... OK
  Applying forms.0002_auto_20141227_0224... OK
  Applying forms.0003_emailfield... OK
  Applying forms.0004_auto_20150517_0510... OK
  Applying forms.0005_auto_20151026_1600... OK
  Applying forms.0006_auto_20170425_2225... OK
  Applying galleries.0001_initial... OK
  Applying galleries.0002_auto_20141227_0224... OK
  Applying generic.0001_initial... OK
  Applying generic.0002_auto_20141227_0224... OK
  Applying generic.0003_auto_20170411_0504... OK
  Applying pages.0002_auto_20141227_0224... OK
  Applying pages.0003_auto_20150527_1555... OK
  Applying pages.0004_auto_20170411_0504... OK
  Applying redirects.0001_initial... OK
  Applying sessions.0001_initial... OK
  Applying sites.0002_alter_domain_unique... OK
  Applying twitter.0001_initial... OK
```

Crearemos un usuario para poder administrarlas.
```shell
(despliegue) fran@debian:~/GitHub/cms$ python3 manage.py createsuperuser
Username (leave blank to use 'fran'): 
Email address: frandh1997@gmail.com
Password: 
Password (again): 
Superuser created successfully.
```

Ejecutamos el servidor web.
```shell
(despliegue) fran@debian:~/GitHub/cms$ python3 manage.py runserver
              .....
          _d^^^^^^^^^b_
       .d''           ``b.
     .p'                `q.
    .d'                   `b.
   .d'                     `b.   * Mezzanine 4.3.1
   ::                       ::   * Django 1.11.29
  ::    M E Z Z A N I N E    ::  * Python 3.7.3
   ::                       ::   * SQLite 3.27.2
   `p.                     .q'   * Linux 4.19.0-16-amd64
    `p.                   .q'
     `b.                 .d'
       `q..          ..p'
          ^q........p^
              ''''

Performing system checks...

System check identified no issues (0 silenced).
April 13, 2021 - 11:00:12
Django version 1.11.29, using settings 'cms.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.
```

Accedemos al puerto indicado (127.0.0.1:8000) y podremos ver la aplicación.
![PracticaImg](images/iaw/Home-Mezzanine.png "home web mezzanine")

Ahora procederemos a realizar una nueva entrada y modificaremos algunas cosas como el titulo también añadiremos links.
![PracticaImg](images/iaw/Entrada-Mezzanine.png "nueva entrada mezzanine")

Ahora realizaremos un dumpdata para guardar información de la base de datos en un fichero para poder migrarlo despues.
```shell
(despliegue) fran@debian:~/GitHub/cms$ python3 manage.py dumpdata > backup.json
```

Crearemos un repositorio en GitHub y guardaremos los datos, en mi caso es: https://github.com/franmadu6/Mezzanine-OpenStack


Accederemos a Freston y crearemos un nuevo registro DNS que llamaremos "python".
```shell

```

```shell

```

```shell

```

```shell

```

```shell

```

```shell

```

```shell

```

```shell

```

```shell

```

```shell

```