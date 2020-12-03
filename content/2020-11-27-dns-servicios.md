---
date: 2020-11-27
title: "Práctica: Servidor DNS"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - SRI
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

```shell
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

        config.vm.define :servidordns do |servidordns|
                servidordns.vm.box = "generic/debian10"
                servidordns.vm.hostname = "servidorDNS"
                servidordns.vm.network :public_network,:bridge=>"wlo1"
                servidordns.vm.network :private_network, ip: "192.168.100.155"
        end

        config.vm.define :cliente do |cliente|
                cliente.vm.box = "generic/debian10"
                cliente.vm.hostname = "cliente"
                cliente.vm.network :public_network,:bridge=>"wlo1"
                cliente.vm.network :private_network, ip: "192.168.100.156"
        end
end
```

<hr>

## Servidor DNSmasq

Instala el servidor dns dnsmasq en pandora.iesgn.org y configúralo para que los clientes puedan conocer los nombres necesarios.

<div style="background-color:#ff5733; border-radius:0.5em;  border-color: black;">

* Tarea 1 (1 punto): Modifica los clientes para que utilicen el nuevo servidor dns. Realiza una consulta a www.iesgn.org, y a www.josedomingo.org. Realiza una prueba de funcionamiento para comprobar que el servidor dnsmasq funciona como cache dns. Muestra el fichero hosts del cliente para demostrar que no estás utilizando resolución estática. Realiza una consulta directa al servidor dnsmasq. ¿Se puede realizar resolución inversa?. Documenta la tarea en redmine.
</div>

__Configuración del Servidor:__

Intalamos dnsmasq:
```shell
vagrant@servidor:~$ sudo apt-get install dnsmasq
```

**Creamos las paginas www.iesgn.org y departamentos.iesgn.org con apache2**

Modificamos /etc/hosts:
```shell
192.168.100.155 www.iesgn.org
192.168.100.155 departamentos.iesgn.org
```

Modificamos el fichero /etc/dnsmasq.conf:
```shell
strict-order
interface=eth2
```

En /etc/resolv.conf
```shell
nameserver 192.168.100.1
```

Reiniciamos servicios
```shell
sudo systemctl restart dnsmasq.service
```

__Configuración del cliente:__

Instralamos la paqueteria:
```shell
vagrant@cliente:~$ sudo apt-get install dnsutils
```

En /etc/resolv.conf
```shell
nameserver 192.168.100.1
```

Comprobación:
```shell
vagrant@cliente:~$ dig www.josedomingo.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> www.josedomingo.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 57262
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 5, ADDITIONAL: 6

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 79aa374f36939b00c83fb1ce5fc8992c80d0da518c9221f2 (good)
;; QUESTION SECTION:
;www.josedomingo.org.		IN	A

;; ANSWER SECTION:
www.josedomingo.org.	56	IN	CNAME	playerone.josedomingo.org.
playerone.josedomingo.org. 717	IN	A	137.74.161.90

;; AUTHORITY SECTION:
josedomingo.org.	35965	IN	NS	ns5.cdmondns-01.com.
josedomingo.org.	35965	IN	NS	ns3.cdmon.net.
josedomingo.org.	35965	IN	NS	ns2.cdmon.net.
josedomingo.org.	35965	IN	NS	ns1.cdmon.net.
josedomingo.org.	35965	IN	NS	ns4.cdmondns-01.org.

;; ADDITIONAL SECTION:
ns1.cdmon.net.		106292	IN	A	35.189.106.232
ns2.cdmon.net.		106292	IN	A	35.195.57.29
ns3.cdmon.net.		106292	IN	A	35.157.47.125
ns4.cdmondns-01.org.	35965	IN	A	52.58.66.183
ns5.cdmondns-01.com.	106292	IN	A	52.59.146.62

;; Query time: 1 msec
;; SERVER: 192.168.100.1#53(192.168.100.1)
;; WHEN: Thu Dec 03 07:52:12 UTC 2020
;; MSG SIZE  rcvd: 322

vagrant@cliente:~$ dig www.iesgn.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> www.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 65398
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.iesgn.org.			IN	A

;; ANSWER SECTION:
www.iesgn.org.		0	IN	A	192.168.100.155

;; Query time: 0 msec
;; SERVER: 192.168.100.1#53(192.168.100.1)
;; WHEN: Thu Dec 03 07:52:54 UTC 2020
;; MSG SIZE  rcvd: 58

vagrant@cliente:~$ dig departamentos.iesgn.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> departamentos.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 7942
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;departamentos.iesgn.org.	IN	A

;; ANSWER SECTION:
departamentos.iesgn.org. 0	IN	A	192.168.100.155

;; Query time: 0 msec
;; SERVER: 192.168.100.1#53(192.168.100.1)
;; WHEN: Thu Dec 03 07:53:33 UTC 2020
;; MSG SIZE  rcvd: 68
```

Consulta directa al servidor dnsmasq:
```shell
vagrant@cliente:~$ dig -x 192.168.100.155

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> -x 192.168.100.155
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 62390
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;155.100.168.192.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
155.100.168.192.in-addr.arpa. 0	IN	PTR	www.iesgn.org.

;; Query time: 0 msec
;; SERVER: 192.168.100.1#53(192.168.100.1)
;; WHEN: Thu Dec 03 07:54:13 UTC 2020
;; MSG SIZE  rcvd: 84
```

¿Se puede realizar resolución inversa?
No, no es capaz de realizar preguntas recursivas.

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

**Configuración en el Servidor:**

Instalamos paquetería:
```shell
vagrant@servidorDNS:~$ sudo apt-get install bind9
```
**Recuerda apagar o desistalar el servidor DNSMasq anteriormente instalado**
```shell
vagrant@servidorDNS:~$ sudo systemctl stop dnsmasq.service
```

Resolución directa:(en  /etc/bind/named.conf.local)
```shell
zone "iesgn.org" {
type master;
file "db.iesgn.org";
};

zone "100.168.192.in-addr.arpa" {
type master;
file "db.192.168.100";
};
```

Vamos a crear dos ficheros:

El fichero /var/cache/bind/db.iesgn.org

```shell
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     madu.iesgn.org.   frandh1997.gmail.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      madu.iesgn.org.
@       IN      MX 10   correo.iesgn.org.

$ORIGIN iesgn.org.
madu            IN      A       192.168.100.155
correo          IN      A       192.168.100.200
ftp             IN      A       192.168.100.201
www             IN      CNAME   madu
departamentos   IN      CNAME   madu
```

Y el fichero /var/cache/bind/db.192.168.100

```shell
$TTL 86400 ; 1 day
@ IN SOA madu.iesgn.org. frandh1997.gmail.com. (
 12998 ; serial
 21600 ; refresh (6 hours)
 3600 ; retry (1 hour)
 604800 ; expire (1 week)
 21600 ; minimum (6 hours)
 )
@ IN NS madu.iesgn.orgg.

$ORIGIN 100.168.192.in-addr.arpa.
155 IN PTR www.iesgn.org.
155 IN PTR departamentos.iesgn.org.
```

<div style="background-color:#ff5733; border-radius:1em;  border-color: black;">

* Tarea 3 (1 puntos): Realiza las consultas dig/nslookup desde los clientes preguntando por los siguientes:
    * Dirección de pandora.iesgn.org, www.iesgn.org, ftp.iesgn.org
    * El servidor DNS con autoridad sobre la zona del dominio iesgn.org
    * El servidor de correo configurado para iesgn.org
    * La dirección IP de www.josedomingo.org
    * Una resolución inversa
</div>

* Dirección de pandora.iesgn.org, www.iesgn.org, ftp.iesgn.org
```shell
vagrant@cliente:~$ dig madu.iesgn.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> madu.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 26578
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 456d9ca9940c96f34291b0355fc8ab94100afc289509f5a6 (good)
;; QUESTION SECTION:
;madu.iesgn.org.			IN	A

;; ANSWER SECTION:
madu.iesgn.org.		604800	IN	A	192.168.100.155

;; AUTHORITY SECTION:
iesgn.org.		604800	IN	NS	madu.iesgn.org.

;; Query time: 1 msec
;; SERVER: 192.168.100.155#53(192.168.100.155)
;; WHEN: Thu Dec 03 09:10:44 UTC 2020
;; MSG SIZE  rcvd: 101
```
```shell
vagrant@cliente:~$ dig www.iesgn.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> www.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 56855
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 8754ac6311b386f3ecc6ecc15fc8aba36e540a3a0b1a0a00 (good)
;; QUESTION SECTION:
;www.iesgn.org.			IN	A

;; ANSWER SECTION:
www.iesgn.org.		604800	IN	CNAME	madu.iesgn.org.
madu.iesgn.org.		604800	IN	A	192.168.100.155

;; AUTHORITY SECTION:
iesgn.org.		604800	IN	NS	madu.iesgn.org.

;; Query time: 1 msec
;; SERVER: 192.168.100.155#53(192.168.100.155)
;; WHEN: Thu Dec 03 09:10:59 UTC 2020
;; MSG SIZE  rcvd: 119
```
```shell
vagrant@cliente:~$ dig ftp.iesgn.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> ftp.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 26408
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: aad1f238f65f5bb32ad1a9d35fc8abc30da5ac8de9d64c51 (good)
;; QUESTION SECTION:
;ftp.iesgn.org.			IN	A

;; ANSWER SECTION:
ftp.iesgn.org.		604800	IN	A	192.168.100.201

;; AUTHORITY SECTION:
iesgn.org.		604800	IN	NS	madu.iesgn.org.

;; ADDITIONAL SECTION:
madu.iesgn.org.		604800	IN	A	192.168.100.155

;; Query time: 0 msec
;; SERVER: 192.168.100.155#53(192.168.100.155)
;; WHEN: Thu Dec 03 09:11:31 UTC 2020
;; MSG SIZE  rcvd: 121
```

* El servidor DNS con autoridad sobre la zona del dominio iesgn.org
```shell
vagrant@cliente:~$ dig ns iesgn.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> ns iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 12731
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 61af9aa291d6c5065fa57b805fc8a9371b402da74c8a0967 (good)
;; QUESTION SECTION:
;iesgn.org.			IN	NS

;; ANSWER SECTION:
iesgn.org.		604800	IN	NS	madu.iesgn.org.

;; ADDITIONAL SECTION:
madu.iesgn.org.		604800	IN	A	192.168.100.155

;; Query time: 0 msec
;; SERVER: 192.168.100.155#53(192.168.100.155)
;; WHEN: Thu Dec 03 09:00:39 UTC 2020
;; MSG SIZE  rcvd: 101
```

* El servidor de correo configurado para iesgn.org
```shell
vagrant@cliente:~$ dig mx iesgn.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> mx iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 62841
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 96301209c19d659f053a80a55fc8a9cb30a6df7f4f8eed52 (good)
;; QUESTION SECTION:
;iesgn.org.			IN	MX

;; ANSWER SECTION:
iesgn.org.		604800	IN	MX	10 correo.iesgn.org.

;; AUTHORITY SECTION:
iesgn.org.		604800	IN	NS	madu.iesgn.org.

;; ADDITIONAL SECTION:
correo.iesgn.org.	604800	IN	A	192.168.100.200
madu.iesgn.org.		604800	IN	A	192.168.100.155

;; Query time: 0 msec
;; SERVER: 192.168.100.155#53(192.168.100.155)
;; WHEN: Thu Dec 03 09:03:07 UTC 2020
;; MSG SIZE  rcvd: 140
```

* La dirección IP de www.josedomingo.org
```shell
vagrant@cliente:~$ dig www.josedomingo.org
; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> www.josedomingo.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 271
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 5, ADDITIONAL: 6

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 5f6397d74751cd384eb020055fc8abffc2f4212bab4159dc (good)
;; QUESTION SECTION:
;www.josedomingo.org.		IN	A

;; ANSWER SECTION:
www.josedomingo.org.	731	IN	CNAME	playerone.josedomingo.org.
playerone.josedomingo.org. 731	IN	A	137.74.161.90

;; AUTHORITY SECTION:
josedomingo.org.	86229	IN	NS	ns4.cdmondns-01.org.
josedomingo.org.	86229	IN	NS	ns3.cdmon.net.
josedomingo.org.	86229	IN	NS	ns2.cdmon.net.
josedomingo.org.	86229	IN	NS	ns1.cdmon.net.
josedomingo.org.	86229	IN	NS	ns5.cdmondns-01.com.

;; ADDITIONAL SECTION:
ns1.cdmon.net.		172630	IN	A	35.189.106.232
ns2.cdmon.net.		172630	IN	A	35.195.57.29
ns3.cdmon.net.		172630	IN	A	35.157.47.125
ns4.cdmondns-01.org.	86229	IN	A	52.58.66.183
ns5.cdmondns-01.com.	172630	IN	A	52.59.146.62

;; Query time: 1 msec
;; SERVER: 192.168.100.155#53(192.168.100.155)
;; WHEN: Thu Dec 03 09:12:31 UTC 2020
;; MSG SIZE  rcvd: 322


vagrant@cliente:~$ dig 137.74.161.90

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> 137.74.161.90
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 7972
;; flags: qr rd ra ad; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: f77f48ef60509bc623c9faa85fc8abfc0c9e5e107b71e286 (good)
;; QUESTION SECTION:
;137.74.161.90.			IN	A

;; AUTHORITY SECTION:
.			10660	IN	SOA	a.root-servers.net. nstld.verisign-grs.com. 2020120300 1800 900 604800 86400

;; Query time: 0 msec
;; SERVER: 192.168.100.155#53(192.168.100.155)
;; WHEN: Thu Dec 03 09:12:28 UTC 2020
;; MSG SIZE  rcvd: 145
```

* Una resolución inversa
```shell
vagrant@cliente:~$ dig -x 192.168.100.155

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> -x 192.168.100.155
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 8828
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: ead6683541c9828cc51219125fc8aa51aefab226d59fd5d8 (good)
;; QUESTION SECTION:
;155.100.168.192.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
155.100.168.192.in-addr.arpa. 86400 IN	PTR	departamentos.iesgn.org.

;; AUTHORITY SECTION:
100.168.192.in-addr.arpa. 86400	IN	NS	madu.iesgn.orgg.

;; Query time: 0 msec
;; SERVER: 192.168.100.155#53(192.168.100.155)
;; WHEN: Thu Dec 03 09:05:21 UTC 2020
;; MSG SIZE  rcvd: 151
```


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
