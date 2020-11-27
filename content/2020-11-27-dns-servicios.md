---
date: 2020-11-27
title: "Práctica: Servidor DNS"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - Servicios
tags:
    - DNS
    - Bind9
    - Servidor
    - Dominio
---

### Escenario

1. En nuestra red local tenemos un servidor Web que sirve dos páginas web: www.iesgn.org, departamentos.iesgn.org
2. Vamos a instalar en nuestra red local un servidor DNS (lo puedes instalar en el mismo equipo que tiene el servidor web)
3. Voy a suponer en este documento que el nombre del servidor DNS va a ser pandora.iesgn.org. El nombre del servidor de tu prácticas será tunombre.iesgn.org.

<hr>

## Servidor DNSmasq

Instala el servidor dns dnsmasq en pandora.iesgn.org y configúralo para que los clientes puedan conocer los nombres necesarios.

<div style="background-color:#ff5733; border-radius:0.5em;  border-color: black;">

* Tarea 1 (1 punto): Modifica los clientes para que utilicen el nuevo servidor dns. Realiza una consulta a www.iesgn.org, y a www.josedomingo.org. Realiza una prueba de funcionamiento para comprobar que el servidor dnsmasq funciona como cache dns. Muestra el fichero hosts del cliente para demostrar que no estás utilizando resolución estática. Realiza una consulta directa al servidor dnsmasq. ¿Se puede realizar resolución inversa?. Documenta la tarea en redmine.
</div>

<hr>

## Servidor bind9

Desinstala el servidor dnsmasq del ejercicio anterior e instala un servidor dns bind9. Las características del servidor DNS que queremos instalar son las siguientes:

* El servidor DNS se llama pandora.iesgn.org y por supuesto, va a ser el servidor con autoridad para la zona iesgn.org.
* Vamos a suponer que tenemos un servidor para recibir los correos que se llame correo.iesgn.org y que está en la dirección x.x.x.200 (esto es ficticio).
* Vamos a suponer que tenemos un servidor ftp que se llame ftp.iesgn.org y que está en x.x.x.201 (esto es ficticio)
* Además queremos nombrar a los clientes.
* También hay que nombrar a los virtual hosts de apache: www.iesgn.org y departementos.iesgn.org
* Se tienen que configurar la zona de resolución inversa.

<div style="background-color:#ff5733; border-radius:1em;  border-color: black;">

* Tarea 2 (1 puntos): Realiza la instalación y configuración del servidor bind9 con las características anteriomente señaladas. Entrega las zonas que has definido. Muestra al profesor su funcionamiento.
</div>

<div style="background-color:#ff5733; border-radius:1em;  border-color: black;">

* Tarea 3 (1 puntos): Realiza las consultas dig/nslookup desde los clientes preguntando por los siguientes:
    * Dirección de pandora.iesgn.org, www.iesgn.org, ftp.iesgn.org
    * El servidor DNS con autoridad sobre la zona del dominio iesgn.org
    * El servidor de correo configurado para iesgn.org
    * La dirección IP de www.josedomingo.org
    * Una resolución inversa
</div>

<hr>

## Servidor DNS esclavo

El servidor DNS actual funciona como DNS maestro. Vamos a instalar un nuevo servidor DNS que va a estar configurado como DNS esclavo del anterior, donde se van a ir copiando periódicamente las zonas del DNS maestro. Suponemos que el nombre del servidor DNS esclavo se va llamar afrodita.iesgn.org.
<div style="background-color:#ff5733; border-radius:1em;  border-color: black;">

* Tarea 4 (2 puntos): Realiza la instalación del servidor DNS esclavo. Documenta los siguientes apartados:
    * Entrega la configuración de las zonas del maestro y del esclavo.
    * Comprueba si las zonas definidas en el maestro tienen algún error con el comando adecuado.
    * Comprueba si la configuración de named.conf tiene algún error con el comando adecuado.
    * Reinicia los servidores y comprueba en los logs si hay algún error. No olvides incrementar el número de serie en el registro SOA si has modificado la zona en el maestro.
    * Muestra la salida del log donde se demuestra que se ha realizado la transferencia de zona.
</div>

<div style="background-color:#ff5733; border-radius:1em; border-color: black;">

* Tarea 5 (1 punto): Documenta los siguientes apartados:
    * Configura un cliente para que utilice los dos servidores como servidores DNS.
    * Realiza una consulta con dig tanto al maestro como al esclavo para comprobar que las respuestas son autorizadas. ¿En qué te tienes que fijar?
    * Solicita una copia completa de la zona desde el cliente ¿qué tiene que ocurrir?. Solicita una copia completa desde el esclavo ¿qué tiene que ocurrir?
</div>

<div style="background-color:#ff5733; border-radius:1em; border-color: black;">

* Tarea 6 (1 punto): Muestra al profesor el funcionamiento del DNS esclavo:
    * Realiza una consulta desde el cliente y comprueba que servidor está respondiendo.
    * Posteriormente apaga el servidor maestro y vuelve a realizar una consulta desde el cliente ¿quién responde?
</div>

<hr>

## Delegación de dominios

Tenemos un servidor DNS que gestiona la zona correspondiente al nombre de dominio iesgn.org, en esta ocasión queremos delegar el subdominio informatica.iesgn.org para que lo gestione otro servidor DNS. Por lo tanto tenemos un escenario con dos servidores DNS:

* pandora.iesgn.org, es servidor DNS autorizado para la zona iesgn.org.
* ns.informatica.iesgn.org, es el servidor DNS para la zona informatica.iesgn.org y, está instalado en otra máquina.

Los nombres que vamos a tener en ese subdominio son los siguientes:

* www.informatica.iesgn.org corresponde a un sitio web que está alojado en el servidor web del departamento de informática.
* Vamos a suponer que tenemos un servidor ftp que se llame ftp.informatica.iesgn.org y que está en la misma máquina.
* Vamos a suponer que tenemos un servidor para recibir los correos que se llame correo.informatica.iesgn.org.

<div style="background-color:#ff5733; border-radius:1em; border-color: black;">

* Tarea 7 (2 puntos): Realiza la instalación y configuración del nuevo servidor dns con las características anteriormente señaladas. Muestra el resultado al profesor.
</div>

<div style="background-color:#ff5733; border-radius:1em; border-color: black;">

* Tarea 8 (1 punto): Realiza las consultas dig/neslookup desde los clientes preguntando por los siguientes:
    * Dirección de www.informatica.iesgn.org, ftp.informatica.iesgn.org
    * El servidor DNS que tiene configurado la zona del dominio informatica.iesgn.org. ¿Es el mismo que el servidor DNS con autoridad para la zona iesgn.org?
    * El servidor de correo configurado para informatica.iesgn.org
</div>
