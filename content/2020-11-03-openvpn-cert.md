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

Commprobamos que se ha creado la regla de encaminamiento para acceder a los equipos de la 172.22.0.0/16.
<pre style="background-color:powderblue;">
fran@debian:~$ ip r
default via 192.168.1.1 dev wlo1 proto dhcp metric 600 
169.254.0.0/16 dev wlo1 scope link metric 1000 
172.22.0.0/16 via 172.23.0.93 dev tun0 
172.23.0.1 via 172.23.0.93 dev tun0 
172.23.0.93 dev tun0 proto kernel scope link src 172.23.0.94 
192.168.1.0/24 dev wlo1 proto kernel scope link src 192.168.1.139 metric 600 
</pre>

Comprobamos los mensajes de log
<pre style="background-color:powderblue;">
root@debian:/home/fran# cat /var/log/openvpn-sputnik.log
Wed Nov  4 19:10:38 2020 WARNING: file '/etc/ssl/private/maduvpn.key' is group or others accessible
Wed Nov  4 19:10:38 2020 OpenVPN 2.4.7 x86_64-pc-linux-gnu [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Feb 20 2019
Wed Nov  4 19:10:38 2020 library versions: OpenSSL 1.1.1d  10 Sep 2019, LZO 2.10
Wed Nov  4 19:10:38 2020 WARNING: using --pull/--client and --ifconfig together is probably not what you want
Wed Nov  4 19:10:38 2020 TCP/UDP: Preserving recently used remote address: [AF_INET]92.222.86.77:1194
Wed Nov  4 19:10:38 2020 Attempting to establish TCP connection with [AF_INET]92.222.86.77:1194 [nonblock]
Wed Nov  4 19:10:39 2020 TCP connection established with [AF_INET]92.222.86.77:1194
Wed Nov  4 19:10:39 2020 TCP_CLIENT link local: (not bound)
Wed Nov  4 19:10:39 2020 TCP_CLIENT link remote: [AF_INET]92.222.86.77:1194
Wed Nov  4 19:10:40 2020 [sputnik.gonzalonazareno.org] Peer Connection Initiated with [AF_INET]92.222.86.77:1194
Wed Nov  4 19:10:41 2020 TUN/TAP device tun0 opened
Wed Nov  4 19:10:41 2020 /sbin/ip link set dev tun0 up mtu 1500
Wed Nov  4 19:10:41 2020 /sbin/ip addr add dev tun0 local 172.23.0.94 peer 172.23.0.93
Wed Nov  4 19:10:41 2020 WARNING: this configuration may cache passwords in memory -- use the auth-nocache option to prevent this
Wed Nov  4 19:10:41 2020 Initialization Sequence Completed
</pre>

* Cuando hayas establecido la conexión VPN tendrás acceso a la red 172.22.0.0/16 a través de un túnel SSL. Compruébalo haciendo ping a 172.22.0.1

<pre style="background-color:powderblue;">
root@debian:/home/fran# ping 172.22.0.1
PING 172.22.0.1 (172.22.0.1) 56(84) bytes of data.
64 bytes from 172.22.0.1: icmp_seq=1 ttl=63 time=144 ms
64 bytes from 172.22.0.1: icmp_seq=2 ttl=63 time=88.8 ms
64 bytes from 172.22.0.1: icmp_seq=3 ttl=63 time=88.8 ms
64 bytes from 172.22.0.1: icmp_seq=4 ttl=63 time=93.5 ms
^C
--- 172.22.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 8ms
rtt min/avg/max/mdev = 88.801/103.841/144.254/23.411 ms
</pre>

