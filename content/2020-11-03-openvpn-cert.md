---
date: 2020-11-03
title: "Configuración de cliente OpenVPN con certificados X.509"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - HLC
tags:
    - OpenVPN
    - Certificados
---


## Configuración de cliente OpenVPN con certificados X.509



### Para poder acceder a la red local desde el exterior, existe una red privada configurada con OpenVPN que utiliza certificados x509 para autenticar los usuarios y el servidor.

* Genera una clave privada RSA 4096
<pre style="background-color:powderblue;">
root@debian:/home/fran/Documentos# openssl genrsa 4096 > /etc/ssl/private/maduvpn.key
Generating RSA private key, 4096 bit long modulus (2 primes)
.................................++++
....................................
.........................................................++++
e is 65537 (0x010001)
</pre>

* Genera una solicitud de firma de certificado (fichero CSR) y súbelo a gestiona
<pre style="background-color:powderblue;">
root@debian:~# openssl req -new -key /etc/ssl/private/maduvpn.key -out /root/maduvpn.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ES
State or Province Name (full name) [Some-State]:Sevilla
Locality Name (eg, city) []:Dos Hermanas
Organization Name (eg, company) [Internet Widgits Pty Ltd]:IES Gonzalo Nazareno
Organizational Unit Name (eg, section) []:Asir
Common Name (e.g. server FQDN or YOUR name) []:maduvpn  
Email Address []:frandh1997@gmail.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
</pre>

Una vez generado el certificado deberemos ir a gestiona "https://dit.gonzalonazareno.org/gestiona/cert/" subirlo y esperar su regreso.
Nos llegará nuestro archivo .crt y estara certificado por el cetro.

* Instala y configura apropiadamente el cliente openvpn y muestra los registros (logs) del sistema que demuestren que se ha establecido una conexión.

Instalaremos nuestro cliente openvpn
<pre style="background-color:powderblue;">
fran@debian:~$ sudo apt-get install openvpn
</pre>

Ahora con paquete instalado moveremos el certificado a /etc/openvpn
<pre style="background-color:powderblue;">
root@debian:/etc/openvpn# ls
client	maduvpn.crt  server  update-resolv-conf
</pre>

Crearemos un fichero de configuración nuevo y le añadiremos las siguientes lineas
<pre style="background-color:powderblue;">
#sputnik.conf
dev tun
remote sputnik.gonzalonazareno.org
ifconfig 172.23.0.0 255.255.255.0
pull
proto tcp-client
tls-client
remote-cert-tls server
ca /etc/ssl/certs/gonzalonazareno.crt            
cert /etc/openvpn/maduvpn.crt
key /etc/ssl/private/maduvpn.key
comp-lzo
keepalive 10 60
log /var/log/openvpn-sputnik.log
verb 1
</pre>

Reiniciamos el servicio de openvpn
<pre style="background-color:powderblue;">
root@debian:/etc/openvpn# /etc/init.d/openvpn restart
[ ok ] Restarting openvpn (via systemctl): openvpn.service.
</pre>



* Cuando hayas establecido la conexión VPN tendrás acceso a la red 172.22.0.0/16 a través de un túnel SSL. Compruébalo haciendo ping a 172.22.0.1
<pre style="background-color:powderblue;">

</pre>

