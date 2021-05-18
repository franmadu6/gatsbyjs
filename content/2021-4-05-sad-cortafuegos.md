---
date: 2021-04-05
title: "[SAD] - Cortafuegos - OpenStack"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - SAD
tags:
    - Cortafuegos
    - Iptables
    - OpenStack
---

# Cortafuegos

## Vamos a construir un cortafuegos en dulcinea que nos permita controlar el tráfico de nuestra red. El cortafuegos que vamos a construir debe funcionar tras un reinicio.

El primer paso antes de ponernos a configurar la seguridad de nuestra red es necesario la instalación de nftables.
```shell
#instalación
apt install nftables
#activación
systemctl start nftables
#para dejarlo habilitado
systemctl enable nftables
```

## Política por defecto

**La política por defecto que vamos a configurar en nuestro cortafuegos será de tipo DROP.**

**En un principio las tendremos en accept hasta que realicemos todas las reglas o almenos tengamos las reglas de ssh configurada para que podamos trabajar comodamente en nuestra terminal.**

```shell
nft chain inet filter input { policy drop \; }
nft chain inet filter forward { policy drop \; }
nft chain inet filter output { policy drop \; }
```

## NAT

* **Configura de manera adecuada las reglas NAT para que todas las máquinas de nuestra red tenga acceso al exterior.**

```shell
nft add table nat

nft add chain nat postrouting { type nat hook postrouting priority 100 \; }

nft add rule ip nat postrouting oifname "eth0" ip saddr 10.0.1.0/24 counter snat to 10.0.0.11
nft add rule ip nat postrouting oifname "eth0" ip saddr 10.0.2.0/24 counter snat to 10.0.0.11
```

* **Configura de manera adecuada todas las reglas NAT necesarias para que los servicios expuestos al exterior sean accesibles.**

```shell
nft add chain nat prerouting { type nat hook prerouting priority 0 \; }

nft add rule ip nat prerouting iifname "eth0" udp dport 53 counter dnat to 10.0.1.3
nft add rule ip nat prerouting iifname "eth0" tcp dport 80 counter dnat to 10.0.2.4
nft add rule ip nat prerouting iifname "eth0" tcp dport 443 counter dnat to 10.0.2.4
```

## Reglas

**Para cada configuración, hay que mostrar las reglas que se han configurado y una prueba de funcionamiento de la misma:**

### PING

* **Todas las máquinas de las dos redes pueden hacer ping entre ellas.**

**Permitir ping Dulcinea con la red interna y la DMZ**
```shell
nft add rule inet filter forward ip saddr 10.0.1.0/24 iifname "eth1" ip daddr 10.0.2.0/24 oifname "eth2" icmp type echo-request counter accept
nft add rule inet filter forward ip saddr 10.0.2.0/24 iifname "eth2" ip daddr 10.0.1.0/24 oifname "eth1" icmp type echo-reply counter accept
```
```shell
debian@freston:~$ ping 10.0.2.4
PING 10.0.2.4 (10.0.2.4) 56(84) bytes of data.
64 bytes from 10.0.2.4: icmp_seq=1 ttl=63 time=3.08 ms
64 bytes from 10.0.2.4: icmp_seq=2 ttl=63 time=1.55 ms
64 bytes from 10.0.2.4: icmp_seq=3 ttl=63 time=1.54 ms
^C
--- 10.0.2.4 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 5ms
rtt min/avg/max/mdev = 1.538/2.053/3.076/0.723 ms
```

**Permitir ping DMZ con la red interna**
```shell
nft add rule inet filter forward ip saddr 10.0.2.0/24 iifname "eth2" ip daddr 10.0.1.0/24 oifname "eth1" icmp type echo-request counter accept
nft add rule inet filter forward ip saddr 10.0.1.0/24 iifname "eth1" ip daddr 10.0.2.0/24 oifname "eth2" icmp type echo-reply counter accept
```
```shell
[centos@quijote ~]$ ping 10.0.1.3
PING 10.0.1.3 (10.0.1.3) 56(84) bytes of data.
64 bytes from 10.0.1.3: icmp_seq=1 ttl=63 time=1.44 ms
64 bytes from 10.0.1.3: icmp_seq=2 ttl=63 time=1.86 ms
64 bytes from 10.0.1.3: icmp_seq=3 ttl=63 time=1.61 ms
^C
--- 10.0.1.3 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 5ms
rtt min/avg/max/mdev = 1.435/1.633/1.859/0.177 ms
```

**Permitir ping red interna con la DMZ.**
```shell
nft add rule inet filter output ip daddr 10.0.1.0/24 oifname "eth1" icmp type echo-request counter accept
nft add rule inet filter input ip saddr 10.0.1.0/24 iifname "eth1" icmp type echo-reply counter accept
```
```shell
root@dulcinea:/home/debian# ping 10.0.1.3
PING 10.0.1.3 (10.0.1.3) 56(84) bytes of data.
64 bytes from 10.0.1.3: icmp_seq=1 ttl=64 time=1.29 ms
64 bytes from 10.0.1.3: icmp_seq=2 ttl=64 time=0.895 ms
64 bytes from 10.0.1.3: icmp_seq=3 ttl=64 time=0.746 ms
^C
--- 10.0.1.3 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 5ms
rtt min/avg/max/mdev = 0.746/0.975/1.286/0.230 ms
```

```shell
nft add rule inet filter output ip daddr 10.0.2.0/24 oifname "eth2" icmp type echo-request counter accept
nft add rule inet filter input ip saddr 10.0.2.0/24 iifname "eth2" icmp type echo-reply counter accept
```
```shell
root@dulcinea:/home/debian# ping 10.0.2.4
PING 10.0.2.4 (10.0.2.4) 56(84) bytes of data.
64 bytes from 10.0.2.4: icmp_seq=1 ttl=64 time=2.35 ms
64 bytes from 10.0.2.4: icmp_seq=2 ttl=64 time=1.10 ms
64 bytes from 10.0.2.4: icmp_seq=3 ttl=64 time=1.39 ms
^C
--- 10.0.2.4 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 5ms
rtt min/avg/max/mdev = 1.097/1.610/2.345/0.533 ms
```

* **Todas las máquinas pueden hacer ping a una máquina del exterior.**

**Permitir ping red interna al exterior.**
```shell
nft add rule inet filter forward ip saddr 10.0.1.0/24 iifname "eth1" oifname "eth0" icmp type echo-request counter accept
nft add rule inet filter forward ip daddr 10.0.1.0/24 iifname "eth0" oifname "eth1" icmp type echo-reply counter accept
```
```shell
debian@freston:~$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=54 time=42.2 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=54 time=41.6 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=54 time=42.2 ms
^C
--- 1.1.1.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 6ms
rtt min/avg/max/mdev = 41.589/41.972/42.168/0.270 ms
```

**Permitir ping DMZ al exterior.**
```shell
nft add rule inet filter forward ip saddr 10.0.2.0/24 iifname "eth2" oifname "eth0" icmp type echo-request counter accept
nft add rule inet filter forward ip daddr 10.0.2.0/24 iifname "eth0" oifname "eth2" icmp type echo-reply counter accept
```
```shell
[centos@quijote ~]$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=54 time=43.6 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=54 time=42.2 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=54 time=42.3 ms
^C
--- 1.1.1.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 5ms
rtt min/avg/max/mdev = 42.172/42.695/43.628/0.661 ms
```

**Permitir ping de Dulcinea al exterior.**
```shell
nft add rule inet filter input iifname "eth0" icmp type echo-request counter accept
nft add rule inet filter output oifname "eth0" icmp type echo-reply counter accept
```
```shell
root@dulcinea:/home/debian# ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=55 time=69.3 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=55 time=40.8 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=55 time=41.2 ms
^C
--- 1.1.1.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 5ms
rtt min/avg/max/mdev = 40.796/50.423/69.322/13.365 ms
```

* **Desde el exterior se puede hacer ping a dulcinea.**

```shell
nft add rule inet filter input iifname "eth0" icmp type echo-request counter accept
nft add rule inet filter output oifname "eth0" icmp type echo-reply counter accept
```
```shell
fran@debian:~$ ping 172.22.201.38
PING 172.22.201.38 (172.22.201.38) 56(84) bytes of data.
64 bytes from 172.22.201.38: icmp_seq=1 ttl=63 time=2.87 ms
64 bytes from 172.22.201.38: icmp_seq=2 ttl=63 time=1.24 ms
64 bytes from 172.22.201.38: icmp_seq=3 ttl=63 time=1.16 ms
^C
--- 172.22.201.38 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 5ms
rtt min/avg/max/mdev = 1.156/1.755/2.872/0.791 ms
```

* **A dulcinea se le puede hacer ping desde la DMZ, pero desde la LAN se le debe rechazar la conexión (REJECT).**

**Rechazar ping de red interna hacia Dulcinea.**
```shell
nft add rule inet filter input ip saddr 10.0.1.0/24 iifname "eth1" icmp type echo-request counter reject
```
```shell
debian@freston:~$ ping 10.0.1.7
PING 10.0.1.7 (10.0.1.7) 56(84) bytes of data.
From 10.0.1.7 icmp_seq=1 Destination Port Unreachable
From 10.0.1.7 icmp_seq=2 Destination Port Unreachable
From 10.0.1.7 icmp_seq=3 Destination Port Unreachable
^C
--- 10.0.1.7 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 4ms
```

**Permitir ping de DMZ hacia Dulcinea.**
```shell
nft add rule inet filter input ip saddr 10.0.2.0/24 iifname "eth2" icmp type echo-request counter accept
nft add rule inet filter output ip daddr 10.0.2.0/24 oifname "eth2" icmp type echo-reply counter accept
```
```shell
[centos@quijote ~]$ ping 10.0.2.6
PING 10.0.2.6 (10.0.2.6) 56(84) bytes of data.
64 bytes from 10.0.2.6: icmp_seq=1 ttl=64 time=1.36 ms
64 bytes from 10.0.2.6: icmp_seq=2 ttl=64 time=1.48 ms
64 bytes from 10.0.2.6: icmp_seq=3 ttl=64 time=1.48 ms
^C
--- 10.0.2.6 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 6ms
rtt min/avg/max/mdev = 1.356/1.439/1.481/0.058 ms
```


### ssh

* **Podemos acceder por ssh a todas las máquinas.**

LAN
```shell
nft add rule inet filter output ip daddr 10.0.1.0/24 oifname "eth1" tcp dport 22 ct state new,established counter accept
nft add rule inet filter input ip saddr 10.0.1.0/24 iifname "eth1" tcp sport 22 ct state established counter accept
```
```shell
root@dulcinea:/home/debian# ssh debian@freston
debian@freston's password: 
Linux freston.madu.gonzalonazareno.org 4.19.0-13-cloud-amd64 #1 SMP Debian 4.19.160-2 (2020-11-28) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue May 11 12:54:43 2021 from 10.0.1.7
debian@freston:~$ 
```

DMZ
```shell
nft add rule inet filter output ip daddr 10.0.2.0/24 oifname "eth2" tcp dport 22 ct state new,established counter accept
nft add rule inet filter input ip saddr 10.0.2.0/24 iifname "eth2" tcp sport 22 ct state established counter accept
```
```shell
root@dulcinea:/home/debian# ssh centos@quijote
Warning: the ECDSA host key for 'quijote' differs from the key for the IP address '10.0.2.4'
Offending key for IP in /root/.ssh/known_hosts:5
Matching host key in /root/.ssh/known_hosts:7
Are you sure you want to continue connecting (yes/no)? yes
centos@quijote's password: 
Last login: Tue May 11 12:45:35 2021 from 10.0.2.6
[centos@quijote ~]$ 
```

Dulcinea
```shell
#desde la red del gonzalonazareno
nft add rule inet filter input ip saddr 172.22.0.0/16 iifname "eth0" tcp dport 22 ct state new,established counter accept
nft add rule inet filter output ip daddr 172.22.0.0/16 oifname "eth0" tcp sport 22 ct state established counter accept

#desde la vpn externa novnc
root@dulcinea:/home/debian# nft add rule inet filter input ip saddr 172.29.0.0/16 iifname "eth0" tcp dport 22 ct state new,established counter accept
root@dulcinea:/home/debian# nft add rule inet filter output ip daddr 172.29.0.0/16 oifname "eth0" tcp sport 22 ct state established counter accept

```
```shell
root@debian:/home/fran# ssh debian@dulcinea
Linux dulcinea.madu.gonzalonazareno.org 4.19.0-14-cloud-amd64 #1 SMP Debian 4.19.171-2 (2021-01-30) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue May 11 12:38:55 2021 from 172.22.8.117
debian@dulcinea:~$ 
```

* **Todas las máquinas pueden hacer ssh a máquinas del exterior.**

LAN
```shell
nft add rule inet filter forward ip saddr 10.0.1.0/24 iifname "eth1" oifname "eth0" tcp dport 22 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.1.0/24 iifname "eth0" oifname "eth1" tcp sport 22 ct state established counter accept
```
```shell
debian@freston:~$ ssh debian@51.178.19.140
debian@51.178.19.140: Permission denied (publickey).
```

DMZ
```shell
nft add rule inet filter forward ip saddr 10.0.2.0/24 iifname "eth2" oifname "eth0" tcp dport 22 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.2.0/24 iifname "eth0" oifname "eth2" tcp sport 22 ct state established counter accept
```
```shell
[centos@quijote ~]$ ssh debian@51.178.19.140
debian@51.178.19.140: Permission denied (publickey).
```


* **La máquina dulcinea tiene un servidor ssh escuchando por el puerto 22, pero al acceder desde el exterior habrá que conectar al puerto 2222.**

```shell
nft add rule inet filter output oifname "eth0" tcp dport 22 ct state new,established counter accept
nft add rule inet filter input iifname "eth0" tcp sport 22 ct state established counter accept
```
```shell
root@dulcinea:~# ssh debian@51.178.19.140
Linux vps 4.19.0-13-cloud-amd64 #1 SMP Debian 4.19.160-2 (2021-04-12) x86_64


The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
No mail.
Last login: Mon Apr 12 11:52:17 2021 from 80.59.1.152
```

### DNS

* **El único dns que pueden usar los equipos de las dos redes es freston, no pueden utilizar un DNS externo.**

```shell
nft add rule inet filter forward ip saddr 10.0.2.0/24 iifname "eth2" ip daddr 10.0.1.3 oifname "eth1" udp dport 53 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.2.0/24 iifname "eth1" ip saddr 10.0.1.3 oifname "eth2" udp sport 53 ct state established counter accept
```
```shell
ubuntu@sancho:~$ dig www.madu.gonzalonazareno.org

; <<>> DiG 9.16.1-Ubuntu <<>> www.madu.gonzalonazareno.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 31355
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;www.madu.gonzalonazareno.org.	IN	A

;; ANSWER SECTION:
www.madu.gonzalonazareno.org. 86400 IN	CNAME	dulcinea.madu.gonzalonazareno.org.
dulcinea.madu.gonzalonazareno.org. 7199	IN A	172.22.201.38

;; Query time: 19 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Wed May 12 20:04:29 CEST 2021
;; MSG SIZE  rcvd: 96
```
```shell
ubuntu@sancho:~$ dig @8.8.8.8 google.es

; <<>> DiG 9.16.1-Ubuntu <<>> @8.8.8.8 google.es
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 37197
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;google.es.			IN	A

;; ANSWER SECTION:
google.es.		299	IN	A	142.250.184.3

;; Query time: 63 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Wed May 12 20:05:41 CEST 2021
;; MSG SIZE  rcvd: 54
```
```shell
[centos@quijote ~]$ dig www.madu.gonzalonazareno.org

; <<>> DiG 9.11.20-RedHat-9.11.20-5.el8_3.1 <<>> www.madu.gonzalonazareno.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 31612
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 0dfd2e1745f99938bcb05bd7609c192ae655908279420efe (good)
;; QUESTION SECTION:
;www.madu.gonzalonazareno.org.	IN	A

;; ANSWER SECTION:
www.madu.gonzalonazareno.org. 86400 IN	CNAME	quijote.madu.gonzalonazareno.org.
quijote.madu.gonzalonazareno.org. 86400	IN A	10.0.2.4

;; AUTHORITY SECTION:
madu.gonzalonazareno.org. 86400	IN	NS	freston.madu.gonzalonazareno.org.

;; ADDITIONAL SECTION:
freston.madu.gonzalonazareno.org. 86400	IN A	10.0.1.3

;; Query time: 2 msec
;; SERVER: 10.0.1.3#53(10.0.1.3)
;; WHEN: Wed May 12 20:06:34 CEST 2021
;; MSG SIZE  rcvd: 161
```
```shell
[centos@quijote ~]$ dig @8.8.8.8 google.es

; <<>> DiG 9.11.20-RedHat-9.11.20-5.el8_3.1 <<>> @8.8.8.8 google.es
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 39036
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;google.es.			IN	A

;; ANSWER SECTION:
google.es.		299	IN	A	142.250.184.3

;; Query time: 63 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Wed May 12 20:07:05 CEST 2021
;; MSG SIZE  rcvd: 54
```

* **dulcinea puede usar cualquier servidor DNS.**

```shell
nft add rule inet filter output udp dport 53 ct state new,established counter accept
nft add rule inet filter input udp sport 53 ct state established counter accept
```
```shell
root@dulcinea:/home/debian# dig www.madu.gonzalonazareno.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> www.madu.gonzalonazareno.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 45022
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 2a480766e04960533183ecab609c1993a9373a4102fd1371 (good)
;; QUESTION SECTION:
;www.madu.gonzalonazareno.org.	IN	A

;; ANSWER SECTION:
www.madu.gonzalonazareno.org. 86400 IN	CNAME	quijote.madu.gonzalonazareno.org.
quijote.madu.gonzalonazareno.org. 86400	IN A	10.0.2.4

;; AUTHORITY SECTION:
madu.gonzalonazareno.org. 86400	IN	NS	freston.madu.gonzalonazareno.org.

;; ADDITIONAL SECTION:
freston.madu.gonzalonazareno.org. 86400	IN A	10.0.1.3

;; Query time: 1 msec
;; SERVER: 10.0.1.3#53(10.0.1.3)
;; WHEN: Wed May 12 20:08:19 CEST 2021
;; MSG SIZE  rcvd: 161

root@dulcinea:/home/debian# dig @8.8.8.8 google.es

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> @8.8.8.8 google.es
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 6506
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;google.es.			IN	A

;; ANSWER SECTION:
google.es.		215	IN	A	142.250.184.3

;; Query time: 239 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Wed May 12 20:08:29 CEST 2021
;; MSG SIZE  rcvd: 54
```

* **Tenemos que permitir consultas dns desde el exterior a freston, para que, por ejemplo, papion-dns pueda preguntar.**

```shell
nft add rule inet filter forward ip daddr 10.0.1.3 iifname "eth0" oifname "eth1" udp dport 53 ct state new,established counter accept
nft add rule inet filter forward ip saddr 10.0.1.3 iifname "eth1" oifname "eth0" udp sport 53 ct state established counter accept
```
```shell
hacer en el instituto

fran@debian:~$ dig www.madu.gonzalonazareno.org

; <<>> DiG 9.11.5-P4-5.1+deb10u5-Debian <<>> www.madu.gonzalonazareno.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 9641
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;www.madu.gonzalonazareno.org.	IN	A

;; ANSWER SECTION:
www.madu.gonzalonazareno.org. 900 IN	CNAME	macaco.gonzalonazareno.org.
macaco.gonzalonazareno.org. 900	IN	A	80.59.1.152

;; Query time: 237 msec
;; SERVER: 192.168.2.1#53(192.168.2.1)
;; WHEN: mié may 12 20:09:34 CEST 2021
;; MSG SIZE  rcvd: 94
```

* **Tenemos que permitir consultas DNS al exterior a Freston, para que pueda hacer las preguntas recursivas.**

```shell
nft add rule inet filter forward ip saddr 10.0.1.3 iifname "eth1" oifname "eth0" udp dport 53 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.1.3 iifname "eth0" oifname "eth1" udp sport 53 ct state established counter accept

nft add rule inet filter forward ip saddr 10.0.1.3 iifname "eth1" oifname "eth0" tcp dport 53 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.1.3 iifname "eth0" oifname "eth1" tcp sport 53 ct state established counter accept
```
```shell
[centos@quijote ~]$ dig www.wikipedia.es

; <<>> DiG 9.11.20-RedHat-9.11.20-5.el8_3.1 <<>> www.wikipedia.es
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 36057
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 3, ADDITIONAL: 4

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 250ad09337f424f198924d8b609c1a392f89033a0c6dda0f (good)
;; QUESTION SECTION:
;www.wikipedia.es.		IN	A

;; ANSWER SECTION:
www.wikipedia.es.	86400	IN	CNAME	ncredir-lb.wikimedia.org.
ncredir-lb.wikimedia.org. 600	IN	A	91.198.174.194

;; AUTHORITY SECTION:
wikimedia.org.		45873	IN	NS	ns1.wikimedia.org.
wikimedia.org.		45873	IN	NS	ns2.wikimedia.org.
wikimedia.org.		45873	IN	NS	ns0.wikimedia.org.

;; ADDITIONAL SECTION:
ns0.wikimedia.org.	45872	IN	A	208.80.154.238
ns1.wikimedia.org.	45872	IN	A	208.80.153.231
ns2.wikimedia.org.	45872	IN	A	91.198.174.239

;; Query time: 1120 msec
;; SERVER: 192.168.202.2#53(192.168.202.2)
;; WHEN: Wed May 12 20:11:05 CEST 2021
;; MSG SIZE  rcvd: 229
```

### Base de datos

* **A la base de datos de sancho sólo pueden acceder las máquinas de la DMZ y la LAN.**

```shell
nft add rule inet filter forward ip saddr 10.0.2.0/24 iifname "eth2" ip daddr 10.0.1.10 oifname "eth1" tcp dport 3306 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.2.0/24 iifname "eth1" ip saddr 10.0.1.10 oifname "eth2" tcp sport 3306 ct state established counter accept
```
```shell
[centos@quijote ~]$ mysql -u quijote -p -h bd.madu.gonzalonazareno.org
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 309
Server version: 10.3.25-MariaDB-0ubuntu0.20.04.1 Ubuntu 20.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> Ctrl-C -- exit!
Aborted
```

### Web

* **Las páginas web de quijote (80, 443) pueden ser accedidas desde todas las máquinas de nuestra red y desde el exterior.**

LAN
```shell
nft add rule inet filter forward ip saddr 10.0.1.0/24 iifname "eth1" ip daddr 10.0.2.4 oifname "eth2" tcp dport 80 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.1.0/24 iifname "eth2" ip saddr 10.0.2.4 oifname "eth1" tcp sport 80 ct state established counter accept

nft add rule inet filter forward ip saddr 10.0.1.0/24 iifname "eth1" ip daddr 10.0.2.4 oifname "eth2" tcp dport 443 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.1.0/24 iifname "eth2" ip saddr 10.0.2.4 oifname "eth1" tcp sport 443 ct state established counter accept
```
```shell
debian@freston:~$ curl http://www.madu.gonzalonazareno.org
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>301 Moved Permanently</title>
</head><body>
<h1>Moved Permanently</h1>
<p>The document has moved <a href="https://www.madu.gonzalonazareno.org/">here</a>.</p>
</body></html>
```

DMZ
```shell
[centos@quijote ~]$ curl http://www.madu.gonzalonazareno.org
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>301 Moved Permanently</title>
</head><body>
<h1>Moved Permanently</h1>
<p>The document has moved <a href="https://www.madu.gonzalonazareno.org/">here</a>.</p>
</body></html>
```

Dulcinea
```shell
nft add rule inet filter output ip daddr 10.0.2.4 oifname "eth2" tcp dport 80 ct state new,established counter accept
nft add rule inet filter input ip saddr 10.0.2.4 iifname "eth2" tcp sport 80 ct state established counter accept

nft add rule inet filter output ip daddr 10.0.2.4 oifname "eth2" tcp dport 443 ct state new,established counter accept
nft add rule inet filter input ip saddr 10.0.2.4 iifname "eth2" tcp sport 443 ct state established counter accept
```
```shell
root@dulcinea:/home/debian# curl http://www.madu.gonzalonazareno.org
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>301 Moved Permanently</title>
</head><body>
<h1>Moved Permanently</h1>
<p>The document has moved <a href="https://www.madu.gonzalonazareno.org/">here</a>.</p>
</body></html>
```

```shell
nft add rule inet filter forward ip daddr 10.0.2.4 iifname "eth0" oifname "eth2" tcp dport 80 ct state new,established counter accept
nft add rule inet filter forward ip saddr 10.0.2.4 iifname "eth2" oifname "eth0" tcp sport 80 ct state established counter accept

nft add rule inet filter forward ip daddr 10.0.2.4 iifname "eth0" oifname "eth2" tcp dport 443 ct state new,established counter accept
nft add rule inet filter forward ip saddr 10.0.2.4 iifname "eth2" oifname "eth0" tcp sport 443 ct state established counter accept
```
```shell
debian@dulcinea:~$ curl http://www.madu.gonzalonazareno.org
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>301 Moved Permanently</title>
</head><body>
<h1>Moved Permanently</h1>
<p>The document has moved <a href="https://www.madu.gonzalonazareno.org/">here</a>.</p>
</body></html>
```

### Más servicios

* **Configura de manera adecuada el cortafuegos, para otros servicios que tengas instalado en tu red (ldap, correo, ...)**


**Permitimos que todas las máquinas puedan acceder a los puertos 80 y 443 del exterior (necesario para las actualizaciones).**

LAN
```shell
nft add rule inet filter forward ip saddr 10.0.1.0/24 iifname "eth1" oifname "eth0" tcp dport 80 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.1.0/24 iifname "eth0" oifname "eth1" tcp sport 80 ct state established counter accept

nft add rule inet filter forward ip saddr 10.0.1.0/24 iifname "eth1" oifname "eth0" tcp dport 443 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.1.0/24 iifname "eth0" oifname "eth1" tcp sport 443 ct state established counter accept
```
```shell
debian@freston:~$ sudo apt update
Get:1 http://security.debian.org/debian-security buster/updates InRelease [65.4 kB]
Get:2 http://deb.debian.org/debian buster InRelease [121 kB]
Get:3 http://deb.debian.org/debian buster-updates InRelease [51.9 kB]
Get:4 http://security.debian.org/debian-security buster/updates/main Sources [184 kB]
Get:5 http://deb.debian.org/debian buster/main Sources [7,841 kB]                      
Get:6 http://security.debian.org/debian-security buster/updates/main amd64 Packages [286 kB]
Get:7 http://security.debian.org/debian-security buster/updates/main Translation-en [148 kB]
Hit:8 http://repo.zabbix.com/zabbix/4.4/debian buster InRelease                        
Get:9 http://deb.debian.org/debian buster-updates/main Sources.diff/Index [6,640 B]    
Get:10 http://deb.debian.org/debian buster-updates/main amd64 Packages.diff/Index [6,640 B]
Get:11 http://deb.debian.org/debian buster-updates/main Translation-en.diff/Index [4,180 B]
Get:12 http://deb.debian.org/debian buster-updates/main Sources 2021-02-07-1359.56.pdiff [959 B]
Get:13 http://deb.debian.org/debian buster-updates/main Sources 2021-04-22-1401.14.pdiff [985 B]
Get:14 http://deb.debian.org/debian buster-updates/main Sources 2021-04-23-1401.02.pdiff [238 B]
Get:14 http://deb.debian.org/debian buster-updates/main Sources 2021-04-23-1401.02.pdiff [238 B]
Get:15 http://deb.debian.org/debian buster-updates/main amd64 Packages 2021-02-07-1359.56.pdiff [2,302 B]
Get:16 http://deb.debian.org/debian buster-updates/main amd64 Packages 2021-04-22-1401.14.pdiff [1,996 B]
Get:17 http://deb.debian.org/debian buster-updates/main amd64 Packages 2021-04-23-1401.02.pdiff [1,127 B]
Get:17 http://deb.debian.org/debian buster-updates/main amd64 Packages 2021-04-23-1401.02.pdiff [1,127 B]
Get:18 http://deb.debian.org/debian buster-updates/main Translation-en 2021-02-07-1359.56.pdiff [1,506 B]
Get:19 http://deb.debian.org/debian buster-updates/main Translation-en 2021-04-22-1401.14.pdiff [1,408 B]
Get:19 http://deb.debian.org/debian buster-updates/main Translation-en 2021-04-22-1401.14.pdiff [1,408 B]
Get:20 http://deb.debian.org/debian buster/main amd64 Packages [7,907 kB]
Get:21 http://deb.debian.org/debian buster/main Translation-en [5,969 kB]
Fetched 22.6 MB in 8s (2,765 kB/s)                                                     
Reading package lists... Done
Building dependency tree       
Reading state information... Done
71 packages can be upgraded. Run 'apt list --upgradable' to see them.
N: Repository 'http://deb.debian.org/debian buster InRelease' changed its 'Version' value from '10.7' to '10.9'
```

DMZ
```shell
nft add rule inet filter forward ip saddr 10.0.2.0/24 iifname "eth2" oifname "eth0" tcp dport 80 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.2.0/24 iifname "eth0" oifname "eth2" tcp sport 80 ct state established counter accept

nft add rule inet filter forward ip saddr 10.0.2.0/24 iifname "eth2" oifname "eth0" tcp dport 443 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.2.0/24 iifname "eth0" oifname "eth2" tcp sport 443 ct state established counter accept
```
```shell
[centos@quijote ~]$ sudo dnf update
Last metadata expiration check: 0:52:25 ago on Wed 12 May 2021 07:42:43 PM CEST.
Dependencies resolved.
Nothing to do.
Complete!
```

Dulcinea
```shell
nft add rule inet filter output oifname "eth0" tcp dport 80 ct state new,established counter accept
nft add rule inet filter input iifname "eth0" tcp sport 80 ct state established counter accept

nft add rule inet filter output oifname "eth0" tcp dport 443 ct state new,established counter accept
nft add rule inet filter input iifname "eth0" tcp sport 443 ct state established counter accept
```
```shell
root@dulcinea:/home/debian# apt update
Get:1 http://security.debian.org/debian-security buster/updates InRelease [65.4 kB]
Get:2 http://deb.debian.org/debian buster InRelease [121 kB]
Get:3 http://deb.debian.org/debian buster-updates InRelease [51.9 kB]
Get:4 http://security.debian.org/debian-security buster/updates/main Sources [184 kB]
Get:5 http://security.debian.org/debian-security buster/updates/main amd64 Packages [286 kB]
Get:6 http://deb.debian.org/debian buster/main Sources [7,841 kB]
Get:7 http://security.debian.org/debian-security buster/updates/main Translation-en [148 kB]
Get:8 http://deb.debian.org/debian buster-updates/main Sources.diff/Index [6,640 B]
Get:9 http://deb.debian.org/debian buster-updates/main amd64 Packages.diff/Index [6,640 B]
Get:10 http://deb.debian.org/debian buster-updates/main Translation-en.diff/Index [4,180 B]
Get:11 http://deb.debian.org/debian buster-updates/main Sources 2021-02-07-1359.56.pdiff [959 B]
Get:12 http://deb.debian.org/debian buster-updates/main Sources 2021-04-22-1401.14.pdiff [985 B]
Get:13 http://deb.debian.org/debian buster-updates/main Sources 2021-04-23-1401.02.pdiff [238 B]
Get:13 http://deb.debian.org/debian buster-updates/main Sources 2021-04-23-1401.02.pdiff [238 B]
Get:14 http://deb.debian.org/debian buster-updates/main amd64 Packages 2021-02-07-1359.56.pdiff [2,302 B]
Get:15 http://deb.debian.org/debian buster-updates/main amd64 Packages 2021-04-22-1401.14.pdiff [1,996 B]
Get:16 http://deb.debian.org/debian buster-updates/main amd64 Packages 2021-04-23-1401.02.pdiff [1,127 B]
Get:16 http://deb.debian.org/debian buster-updates/main amd64 Packages 2021-04-23-1401.02.pdiff [1,127 B]
Get:17 http://deb.debian.org/debian buster-updates/main Translation-en 2021-02-07-1359.56.pdiff [1,506 B]
Get:18 http://deb.debian.org/debian buster-updates/main Translation-en 2021-04-22-1401.14.pdiff [1,408 B]
Get:18 http://deb.debian.org/debian buster-updates/main Translation-en 2021-04-22-1401.14.pdiff [1,408 B]
Get:19 http://deb.debian.org/debian buster/main amd64 Packages [7,907 kB]
Ign:19 http://deb.debian.org/debian buster/main amd64 Packages                         
Get:20 http://deb.debian.org/debian buster/main Translation-en [5,969 kB]
Ign:20 http://deb.debian.org/debian buster/main Translation-en                         
Get:19 http://deb.debian.org/debian buster/main amd64 Packages [7,907 kB]
Get:20 http://deb.debian.org/debian buster/main Translation-en [5,969 kB]
Fetched 13.1 MB in 1min 8s (191 kB/s)                                                  
Reading package lists... Done
Building dependency tree       
Reading state information... Done
50 packages can be upgraded. Run 'apt list --upgradable' to see them.
N: Repository 'http://deb.debian.org/debian buster InRelease' changed its 'Version' value from '10.7' to '10.9'
```

**Permitimos que todas las máquinas puedan acceder al puerto 123 del exterior (necesario para la sincronización NTP).**

LAN
```shell
nft add rule inet filter forward ip saddr 10.0.1.0/24 iifname "eth1" oifname "eth0" udp dport 123 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.1.0/24 iifname "eth0" oifname "eth1" udp sport 123 ct state established counter accept
```
```shell
ubuntu@sancho:~$ timedatectl
               Local time: Wed 2021-05-12 20:38:08 CEST
           Universal time: Wed 2021-05-12 18:38:08 UTC 
                 RTC time: Wed 2021-05-12 18:38:09     
                Time zone: Europe/Madrid (CEST, +0200) 
System clock synchronized: yes                         
              NTP service: active                      
          RTC in local TZ: no  
```

DMZ
```shell
nft add rule inet filter forward ip saddr 10.0.2.0/24 iifname "eth2" oifname "eth0" udp dport 123 ct state new,established counter accept
nft add rule inet filter forward ip daddr 10.0.2.0/24 iifname "eth0" oifname "eth2" udp sport 123 ct state established counter accept
```
```shell
[centos@quijote ~]$ timedatectl
               Local time: Wed 2021-05-12 20:38:56 CEST
           Universal time: Wed 2021-05-12 18:38:56 UTC
                 RTC time: Wed 2021-05-12 18:38:56
                Time zone: Europe/Madrid (CEST, +0200)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```

Dulcinea
```shell
nft add rule inet filter output oifname "eth0" udp dport 123 ct state new,established counter accept
nft add rule inet filter input iifname "eth0" udp sport 123 ct state established counter accept
```
```shell
root@dulcinea:/home/debian# timedatectl
               Local time: Wed 2021-05-12 20:39:29 CEST
           Universal time: Wed 2021-05-12 18:39:29 UTC
                 RTC time: Wed 2021-05-12 18:39:30
                Time zone: Europe/Madrid (CEST, +0200)
System clock synchronized: yes
              NTP service: inactive
          RTC in local TZ: no
```

**Para finalizar guardaremos las reglas en un fichero para que la configuración perdure tras un reinicio**



Ahora es el momento de poner las politicas a drop y guardar el fichero de nftables.

```shell
nft chain inet filter input { policy drop \; }
nft chain inet filter forward { policy drop \; }
```
```shell
nft list ruleset > /etc/nftables.conf
```
