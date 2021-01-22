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

Para comenzar los primero es crear una maquina vagrant con los requisitos que necesitamos
```shell
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

        config.vm.define :integracion do |integracion|
                integracion.vm.box = "generic/debian10"
                integracion.vm.hostname = "integracion"
                integracion.vm.network :public_network,:bridge=>"wlo1"
                integracion.vm.network :private_network, ip: "192.168.100.142"
		    integracion.vm.provision "shell", inline: <<-SHELL
			sudo apt-get update
			sudo apt-get upgrade
			sudo apt-get install git
			sudo apt install -y python3-pip
			sudo apt install build-essential libssl-dev libffi-dev python3-dev
			sudo apt install -y python3-venv
		SHELL
        end

end
```

En el siguiente paso crearemos un entorno virtual y realizaremos la primera prueba de python3 manage.py test.
```shell
vagrant@integracion:~$ git clone https://github.com/josedom24/django_tutorial.git
Cloning into 'django_tutorial'...
remote: Enumerating objects: 37, done.
remote: Counting objects: 100% (37/37), done.
remote: Compressing objects: 100% (32/32), done.
remote: Total 129 (delta 4), reused 24 (delta 3), pack-reused 92
Receiving objects: 100% (129/129), 4.25 MiB | 7.25 MiB/s, done.
Resolving deltas: 100% (28/28), done.
vagrant@integracion:~$ ls
django_tutorial
vagrant@integracion:~$ mkdir environments
vagrant@integracion:~$ cd environments
vagrant@integracion:~/environments$ python3.7 -m venv my_env
vagrant@integracion:~/environments$ ls my_env/
bin  include  lib  lib64  pyvenv.cfg  share
vagrant@integracion:~/environments$ source my_env/bin/activate
(my_env) vagrant@integracion:~/environments$ cd ..
(my_env) vagrant@integracion:~$ cd django_tutorial/
(my_env) vagrant@integracion:~/django_tutorial$ pip install -r requirements.txt 
Collecting asgiref==3.3.0 (from -r requirements.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/c0/e8/578887011652048c2d273bf98839a11020891917f3aa638a0bc9ac04d653/asgiref-3.3.0-py3-none-any.whl
Collecting Django==3.1.3 (from -r requirements.txt (line 2))
  Downloading https://files.pythonhosted.org/packages/7f/17/16267e782a30ea2ce08a9a452c1db285afb0ff226cfe3753f484d3d65662/Django-3.1.3-py3-none-any.whl (7.8MB)
    100% |████████████████████████████████| 7.8MB 209kB/s 
Collecting pytz==2020.4 (from -r requirements.txt (line 3))
  Downloading https://files.pythonhosted.org/packages/12/f8/ff09af6ff61a3efaad5f61ba5facdf17e7722c4393f7d8a66674d2dbd29f/pytz-2020.4-py2.py3-none-any.whl (509kB)
    100% |████████████████████████████████| 512kB 904kB/s 
Collecting sqlparse==0.4.1 (from -r requirements.txt (line 4))
  Downloading https://files.pythonhosted.org/packages/14/05/6e8eb62ca685b10e34051a80d7ea94b7137369d8c0be5c3b9d9b6e3f5dae/sqlparse-0.4.1-py3-none-any.whl (42kB)
    100% |████████████████████████████████| 51kB 2.6MB/s 
Installing collected packages: asgiref, sqlparse, pytz, Django
Successfully installed Django-3.1.3 asgiref-3.3.0 pytz-2020.4 sqlparse-0.4.1
(my_env) vagrant@integracion:~/django_tutorial$ ls
django_tutorial  manage.py  polls  README.md  requirements.txt
(my_env) vagrant@integracion:~/django_tutorial$ python3 manage.py test
Creating test database for alias 'default'...
System check identified no issues (0 silenced).
..........
----------------------------------------------------------------------
Ran 10 tests in 0.032s

OK
Destroying test database for alias 'default'...
```

### Estudia las distintas pruebas que se han realizado, y modifica el código de la aplicación (debes modificar el fichero views.py o los templates, no debes cambiar el fichero tests.py para que al menos una de ella no se ejecute de manera exitosa.

El primer paso sera fijarnos en el archivo tests.py y ver cual de los test que realiza puede ser interesante para la prueba.
```shell
#En test.py
class QuestionIndexViewTests(TestCase):
    def test_no_questions(self):
        """
        If no questions exist, an appropriate message is displayed.
        """
        response = self.client.get(reverse('polls:index'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "No polls are available.")
        self.assertQuerysetEqual(response.context['latest_question_list'], [])
```
Modificaremos el mensaje de "No polls are available." y lo traduciremos al español.

deberemos de buscar el archivo donde se utiliza esa frase.
```shell
(my_env) vagrant@integracion:~$ grep -r "No polls are available." django_tutorial/*
Binary file django_tutorial/polls/__pycache__/tests.cpython-37.pyc matches
django_tutorial/polls/tests.py:        self.assertContains(response, "No polls are available.")
django_tutorial/polls/tests.py:        self.assertContains(response, "No polls are available.")
django_tutorial/polls/templates/polls/index.html:    <p>No polls are available.</p>
```

Modificamos la linea
```shell
{% load static %}

<link rel="stylesheet" type="text/css" href="{% static 'polls/style.css' %}">

{% if latest_question_list %}
    <ul>
    {% for question in latest_question_list %}
    <li><a href="{% url 'polls:detail' question.id %}">{{ question.question_text }}</a></li>
    {% endfor %}
    </ul>
{% else %}
    <p>No hay encuestas disponibles.</p>
{% endif %}
```

Y volvemos a pasar el archivo test.py
```shell
(my_env) vagrant@integracion:~/django_tutorial$ python3 manage.py test
Creating test database for alias 'default'...
System check identified no issues (0 silenced).
..F.F.....
======================================================================
FAIL: test_future_question (polls.tests.QuestionIndexViewTests)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/vagrant/django_tutorial/polls/tests.py", line 73, in test_future_question
    self.assertContains(response, "No polls are available.")
  File "/home/vagrant/environments/my_env/lib/python3.7/site-packages/django/test/testcases.py", line 470, in assertContains
    self.assertTrue(real_count != 0, msg_prefix + "Couldn't find %s in response" % text_repr)
AssertionError: False is not true : Couldn't find 'No polls are available.' in response

======================================================================
FAIL: test_no_questions (polls.tests.QuestionIndexViewTests)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/vagrant/django_tutorial/polls/tests.py", line 51, in test_no_questions
    self.assertContains(response, "No polls are available.")
  File "/home/vagrant/environments/my_env/lib/python3.7/site-packages/django/test/testcases.py", line 470, in assertContains
    self.assertTrue(real_count != 0, msg_prefix + "Couldn't find %s in response" % text_repr)
AssertionError: False is not true : Couldn't find 'No polls are available.' in response

----------------------------------------------------------------------
Ran 10 tests in 0.031s

FAILED (failures=2)
Destroying test database for alias 'default'...
```

Como podemos comprobar nos salta el mensaje de que el test ha fallado y nos dice que no puede encontrar el mensaje de 'No polls are available.' en la aplicación.

<hr>

A continuación vamos a configurar la integración continúa para que cada vez que hagamos un commit se haga la ejecución de test en la herramienta de CI/CD que haya elegido.

### Crea el pipeline en el sistema de CI/CD para que pase automáticamente los tests. Muestra el fichero de configuración y una captura de pantalla con un resultado exitoso de la IC y otro con un error.


<hr>

A continuación vamos a realziar el despliegue coontinuo en un servicio de hosting, por ejemplo heroku.

### Entrega un breve descripción de los pasos más importantes para realizar el despliegue desde el sistema de CI/CS y entrega una prueba de funcionamiento donde se compruebe cómo se hace el despliegue automático.
