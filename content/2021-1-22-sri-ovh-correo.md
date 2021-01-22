---
date: 2021-01-22
title: "Práctica correo ovh"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - SRI
tags:
    - OVH
    - Servidor de Correo
---

<center><img src="https://feedyourweb.com/wp-content/uploads/2017/12/Postfix_logo.png"/></center>

## Práctica: Servidor de correos

### Instala y configura de manera adecuada el servidor de correos en tu máquina de OVH, para tu dominio iesgnXX.es. El nombre del servidor de correo será mail.iesgnXX.es (Este es el nombre que deberá aparecer en el registro MX)

<hr>

#### Gestión de correos desde el servidor

* Tarea 1: Documenta una prueba de funcionamiento, donde envíes desde tu servidor local al exterior. Muestra el log donde se vea el envío. Muestra el correo que has recibido. Muestra el registro SPF.

* Tarea 2: Documenta una prueba de funcionamiento, donde envíes un correo desde el exterior (gmail, hotmail,…) a tu servidor local. Muestra el log donde se vea el envío. Muestra cómo has leído el correo. Muestra el registro MX de tu dominio.


<hr>

#### Uso de alias y redirecciones


* Tarea 3 (No obligatoria): Uso de alias y redirecciones.

<hr>

#### Para asegurar el envío

* Tarea 4 (No obligatoria): Configura de manera adecuada DKIM es tu sistema de correos. Comprueba el registro DKIM en la página https://mxtoolbox.com/dkim.aspx. Configura postfix para que firme los correos que envía. Manda un correo y comprueba la verificación de las firmas en ellos.