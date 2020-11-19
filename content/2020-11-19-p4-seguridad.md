---
date: 2020-11-19
title: "Práctica: Certificados digitales. HTTPS"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - Seguridad
tags:
    - Gpg
    - OpenSSL
---

#### Certificado digital de persona física

## Tarea 1: Instalación del certificado

1. Una vez que hayas obtenido tu certificado, explica brevemente como se instala en tu navegador favorito.
2. Muestra una captura de pantalla donde se vea las preferencias del navegador donde se ve instalado tu certificado.
3. ¿Cómo puedes hacer una copia de tu certificado?, ¿Como vas a realizar la copia de seguridad de tu certificado?. Razona la respuesta.
4. Investiga como exportar la clave pública de tu certificado.

## Tarea 2: Validación del certificado

1. Instala en tu ordenador el software autofirma y desde la página de VALIDe valida tu certificado. Muestra capturas de pantalla donde se comprueba la validación.

## Tarea 3: Firma electrónica

1. Utilizando la página VALIDe y el programa autofirma, firma un documento con tu certificado y envíalo por correo a un compañero.
2. Tu debes recibir otro documento firmado por un compañero y utilizando las herramientas anteriores debes visualizar la firma (Visualizar Firma) y (Verificar Firma). ¿Puedes verificar la firma aunque no tengas la clave pública de tu compañero?, ¿Es necesario estar conectado a internet para hacer la validación de la firma?. Razona tus respuestas.
3. Entre dos compañeros, firmar los dos un documento, verificar la firma para comprobar que está firmado por los dos.

## Tarea 4: Autentificación

1. Utilizando tu certificado accede a alguna página de la administración pública )cita médica, becas, puntos del carnet,…). Entrega capturas de pantalla donde se demuestre el acceso a ellas.

#### HTTPS / SSL

<span style="background-color:red">Antes de hacer esta práctica vamos a crear una página web (puedes usar una página estática o instalar una aplicación web) en un servidor web apache2 que se acceda con el nombre tunombre.iesgn.org.</span>

## Tarea 1: Certificado autofirmado

* El alumno que hace de Autoridad Certificadora deberá entregar una documentación donde explique los siguientes puntos:

     1. Crear su autoridad certificadora (generar el certificado digital de la CA). Mostrar el fichero de configuración de la AC.
     2. Debe recibir el fichero CSR (Solicitud de Firmar un Certificado) de su compañero, debe firmarlo y enviar el certificado generado a su compañero.
     3. ¿Qué otra información debes aportar a tu compañero para que éste configure de forma adecuada su servidor web con el certificado generado?

* El alumno que hace de administrador del servidor web, debe entregar una documentación que describa los siguientes puntos:

     1. Crea una clave privada RSA de 4096 bits para identificar el servidor.
     2. Utiliza la clave anterior para generar un CSR, considerando que deseas acceder al servidor con el FQDN (tunombre.iesgn.org).
     3. Envía la solicitud de firma a la entidad certificadora (su compañero).
     4. Recibe como respuesta un certificado X.509 para el servidor firmado y el certificado de la autoridad certificadora.
     5. Configura tu servidor web con https en el puerto 443, haciendo que las peticiones http se redireccionen a https (forzar https).
     6. Instala ahora un servidor nginx, y realiza la misma configuración que anteriormente para que se sirva la página con HTTPS.

