---
date: 2020-11-25
title: "Tarea OVH. HTTPS"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - SAD
tags:
    - OVH
    - HTTPS
---


## HTTPS (Seguridad)

Vamos a configurar el protocolo HTTPS para el acceso a nuestras aplicaciones, para ello tienes que tener en cuenta los siguiente.

1. Vamos a utilizar el servicio https://letsencrypt.org para solicitar los certificados de nuestras páginas.

2. Explica detenidamente cómo se solicita un certificado en Let's Encrypt. En tu explicación deberás responder a estas preguntas:

    * ¿Qué función tiene el cliente ACME?
    Automatizar la emisión e instalación de certificados con cero tiempo de inactivdad. También tiene modos de expertos para personas que no quieren autoconfiguración.

    * ¿Qué configuración se realiza en el servidor web?
    Los datos enviados usando HTTPS están asegurados por el protocolo TLS (Transport Layer Security), que ofrece 3 capas de protección fundamentales:

    Cifrado . El cifrado de los datos intercambiados los mantiene seguros de miradas indiscretas. Eso significa que mientras el usuario está navegando en un sitio web, nadie puede " escuchar" a sus conversaciones , realizar un seguimiento de sus actividades a través de múltiples páginas o robar su información.

    Integridad de los datos. Los datos no puede ser modificado o dañado durante la transferencia, intencionadamente o no, sin ser detectado.

    Autenticación. Demuestra que los usuarios se comunican con la página web deseada. Protege contra los ataques y construye la confianza del usuario, lo que se traduce en más beneficios para el negocio.


    * ¿Qué pruebas realiza Let's Encrypt para asegurar que somos los administrados del sitio web?

    * ¿Se puede usar el DNS para verificar que somos administradores del sitio?

3. Utiliza dos ficheros de configuración de nginx: uno para la configuración del virtualhost HTTP y otro para la configuración del virtualhost HTTPS.

4. Realiza una redirección o una reescritura para que cuando accedas a HTTP te redirija al sitio HTTPS.

5. Comprueba que se ha creado una tarea cron que renueva el certificado cada 3 meses.

6. Comprueba que las páginas son accesible por HTTPS y visualiza los detalles del certificado que has creado.

7. Modifica la configuración del cliente de Nextcloud para comprobar que sigue en funcionamiento con HTTPS.