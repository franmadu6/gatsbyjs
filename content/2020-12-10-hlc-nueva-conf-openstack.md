---
date: 2020-12-10
title: "Modificación del escenario de OpenStack"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - HLC
tags:
    - OpenStack
    - DMZ
---

Vamos a modificar el escenario que tenemos actualmente en OpenStack para que se adecúe a la realización de todas las prácticas en todos los módulos de 2º, en particular para que tenga una estructura más real a la de varios equipos detrás de un cortafuegos, separando los servidores en dos redes: red interna y DMZ. Para ello vamos a reutilizar todo lo hecho hasta ahora y añadiremos una máquina más: Frestón

![PracticaImg](images/hlc/escenariodmz.png "Imagen de la practica")

* Creación de la red DMZ:
      * Nombre: DMZ de <nombre de usuario>
      * 10.0.2.0/24
![PracticaImg](images/hlc/escenariodmz2.png "Imagen de la practica")

* Creación de las instancias:
      * freston:
          - Debian Buster sobre volumen de 10GB con sabor m1.mini
          - Conectada a la red interna
          - Accesible indirectamente a través de dulcinea
          - IP estática
![PracticaImg](images/hlc/escenariodmz3.png "Imagen de la practica")

Desde el cliente de openstack deshabilitamos la seguridad.
```shell
fran@debian:~$  source ~/.virtualenvs/openstackclient/bin/activate
(openstackclient) fran@debian:~/Documentos$ source Proyecto\ de\ francisco.madu-openrc.sh 
Please enter your OpenStack Password for project Proyecto de francisco.madu as user francisco.madu: 
(openstackclient) fran@debian:~/Documentos$ openstack server remove security group Freston default
(openstackclient) fran@debian:~/Documentos$ openstack port list
+--------------------------------------+----------------------------------------+-------------------+--------------------------------------------------------------------------+--------+
| ID                                   | Name                                   | MAC Address       | Fixed IP Addresses                                                       | Status |
+--------------------------------------+----------------------------------------+-------------------+--------------------------------------------------------------------------+--------+
| 280e513f-5016-44b5-a66e-fb6960e4f8fa |                                        | fa:16:3e:23:87:b2 | ip_address='10.0.1.7', subnet_id='b0fb0d9b-c8da-4790-888c-e190e588d551'  | ACTIVE |
| 3d001afd-f6d2-4348-abb0-70b8babaf005 |                                        | fa:16:3e:8a:5c:d5 | ip_address='10.0.0.8', subnet_id='46cd68e1-2e88-4ba6-9970-431f6f53c13f'  | ACTIVE |
| 4e921875-0585-4258-b7e9-d8c63e23c5c4 |                                        | fa:16:3e:fc:a2:8c | ip_address='10.0.1.8', subnet_id='b0fb0d9b-c8da-4790-888c-e190e588d551'  | ACTIVE |
| 53665f0f-e35a-44d9-896a-313861310021 |                                        | fa:16:3e:18:49:cd | ip_address='10.0.0.1', subnet_id='46cd68e1-2e88-4ba6-9970-431f6f53c13f'  | ACTIVE |
| 5983f2e0-fc9c-49d3-aa25-d80f1d6cbd5c |                                        | fa:16:3e:57:43:51 | ip_address='10.0.1.14', subnet_id='b0fb0d9b-c8da-4790-888c-e190e588d551' | ACTIVE |
| 5f4ef06d-17cf-49e3-b30e-54bcd8a04465 |                                        | fa:16:3e:36:da:86 | ip_address='10.0.0.2', subnet_id='46cd68e1-2e88-4ba6-9970-431f6f53c13f'  | ACTIVE |
| 9273bdf8-b1dd-42b2-b005-3ae51040a31c |                                        | fa:16:3e:06:c6:4e | ip_address='10.0.2.7', subnet_id='be50df48-1769-4b53-9886-7f5352bc086f'  | ACTIVE |
| a1ddef48-4e33-4285-b207-2684a90a2e45 |                                        | fa:16:3e:9f:01:39 | ip_address='10.0.2.3', subnet_id='be50df48-1769-4b53-9886-7f5352bc086f'  | ACTIVE |
| b4099ac2-bcb7-401f-997c-e826f949e117 | escenario1-r1_network_ext-wajhseltwj2t | fa:16:3e:71:9a:c3 | ip_address='10.0.0.12', subnet_id='46cd68e1-2e88-4ba6-9970-431f6f53c13f' | ACTIVE |
| f3fcc1b8-40fa-45b8-86f3-f98793d75800 |                                        | fa:16:3e:68:b4:c0 | ip_address='10.0.0.3', subnet_id='46cd68e1-2e88-4ba6-9970-431f6f53c13f'  | ACTIVE |
+--------------------------------------+----------------------------------------+-------------------+--------------------------------------------------------------------------+--------+
(openstackclient) fran@debian:~/Documentos$ openstack server remove security group Dulcinea default
(openstackclient) fran@debian:~/Documentos$ openstack port set --disable-port-security 9273bdf8-b1dd-42b2-b005-3ae51040a31c
(openstackclient) fran@debian:~/Documentos$ openstack port set --disable-port-security 4e921875-0585-4258-b7e9-d8c63e23c5c4
(openstackclient) fran@debian:~/Documentos$ openstack port set --disable-port-security 3d001afd-f6d2-4348-abb0-70b8babaf005

```


* Modificación de la ubicación de quijote
    * Pasa de la red interna a la DMZ y su direccionamiento tiene que modificarse apropiadamente.
<hr>

Añadiremos la nueva interfaz a Dulcinea por OpenStacks y seguido modificamos el fichero de Dulcinea /etc/network/interfaces:
```shell
debian@dulcinea:~$ sudo nano /etc/network/interfaces

# The normal eth0
allow-hotplug eth0
iface eth0 inet static
 address 10.0.0.8
 netmask 255.255.255.0
 broadcast 10.0.0.255

# Additional interfaces, just in case we're using
# multiple networks
allow-hotplug eth1
iface eth1 inet static
 address 10.0.1.12
 netmask 255.255.255.0
 broadcast 10.0.1.255
 gateway 10.0.1.1

allow-hotplug eth2
iface eth2 inet static
 address 10.0.2.9
 netmask 255.255.255.0
 broadcast 10.0.2.255
 gateway 10.0.2.1


debian@dulcinea:~$ sudo systemctl restart networking
```

Añadimos nueva reglas a nuestro cortafuegos en este caso usaré ntfs y ademas la añadire al fichero /etc/ntfstables.conf para que de esta manera nos podamos olvidar de estar añadiendolas cada vez que reiniciemos.
```shell
#Descargar el paquete de ntftable
sudo apt install nftables
#Habilitar ntftables
debian@francisco-madu:~$ sudo systemctl enable nftables.service
Created symlink /etc/systemd/system/sysinit.target.wants/nftables.service → /lib/systemd/system/nftables.service.
#Añadir la nueva regla
nft add rule ip nat postrouting oifname "eth0" ip saddr 10.0.2.0/24 counter snat to 10.0.0.5
#Añadir la regla del ejercicios pasado
nft add rule ip nat postrouting oifname "eth0" ip saddr 10.0.1.0/24 counter snat to 10.0.0.5
#Mostrar las reglas
debian@francisco-madu:~$ sudo nft list ruleset
table inet filter {
	chain input {
		type filter hook input priority 0; policy accept;
	}

	chain forward {
		type filter hook forward priority 0; policy accept;
	}

	chain output {
		type filter hook output priority 0; policy accept;
	}
}
table ip nat {
	chain postrouting {
		type nat hook postrouting priority 100; policy accept;
		oifname "eth0" ip saddr 10.0.1.0/24 counter packets 44 bytes 3041 snat to 10.0.0.11
		oifname "eth0" ip saddr 10.0.2.0/24 counter packets 31 bytes 2380 snat to 10.0.0.11
	}
}


#Guardarlo en /etc/ntfstables.conf
```

Le añadimos claves para el usuario debian y root.
```shell
debian@freston:~$ sudo passwd debian
New password: 
Retype new password: 
passwd: password updated successfully
debian@freston:~$ sudo passwd root
New password: 
Retype new password: 
passwd: password updated successfully
```
Una vez configurado esto, la quitamos de la red, y la metemos en la red anteriormente creada.

Creación del usuario profesor.
```shell
root@freston:~# useradd profesor -m -s /bin/bash
root@freston:~# su - profesor
root@freston:~# echo "profesor ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
profesor@freston:~$ mkdir .ssh
profesor@freston:~$ nano .ssh/authorized_keys

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfk9mRtOHM3T1KpmGi0KiN2uAM6CDXM3WFcm1wkzKXx7RaLtf9pX+KCuVqHdy/N/9d9wtH7iSmLFX/4gQKQVG00jHiGf3ABufWeIpjmHtT1WaI0+vV47fofEIjDDfSZPlI3p5/c7tefHsIAK6GbQn31yepAcFYy9ZfqAh8H/Y5eLpf3egPZn9Czsvx+lm0I8Q+e/HSayRaiAPUukF57N2nnw7yhPZCHSZJqFbXyK3fVQ/UQVBeNS2ayp0my8X9sIBZnNkcYHFLIWBqJYdnu1ZFhnbu3yy94jmJdmELy3+54hqiwFEfjZAjUYSl8eGPixOfdTgc8ObbHbkHyIrQ91Kz rafa@eco
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmjoVIoZCx4QFXvljqozXGqxxlSvO7V2aizqyPgMfGqnyl0J9YXo6zrcWYwyWMnMdRdwYZgHqfiiFCUn2QDm6ZuzC4Lcx0K3ZwO2lgL4XaATykVLneHR1ib6RNroFcClN69cxWsdwQW6dpjpiBDXf8m6/qxVP3EHwUTsP8XaOV7WkcCAqfYAMvpWLISqYme6e+6ZGJUIPkDTxavu5JTagDLwY+py1WB53eoDWsG99gmvyit2O1Eo+jRWN+mgRHIxJTrFtLS6o4iWeshPZ6LvCZ/Pum12Oj4B4bjGSHzrKjHZgTwhVJ/LDq3v71/PP4zaI3gVB9ZalemSxqomgbTlnT jose@debian
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3AUDWjyPANntK+qwHmlJihKQZ1H+AGN02k06dzRHmkvWiNgou/VcCgowhMTGR+0I6nWVwgRSWKJEUEaMu1r9rEeL63GRtUSepCWpClHJG1CuySuJKVGtRdUq+/szDntpJnJW207a78hTeQLjQsyPvbOqkbulQG7xTRCycdT3bH2UO4JI2d+341gkOlxSG/stPQ52Dsbfb274oMRom5r5f2apD3wbfxE9A6qwm4m70G9NYS7T3uKgCiXegO/3GTJD4UbK0ylGUamG5obdS5yD8Ib12vRCCXWav23SAj/4f9MzAnXX8U4ATM/du2FHZBiIzWVH12LYvIEZpUIVYKPSf alberto@roma

profesor@freston:~$ chmod 700 .ssh/
profesor@freston:~$ chmod 600 .ssh/authorized_keys
```

Configuramos la ip estatica en freston:
```shell
# The normal eth0
allow-hotplug eth0
iface eth0 inet static
 address 10.0.1.14
 netmask 255.255.255.0
 broadcast 10.0.1.255
 gateway 10.0.1.10
 ```

 Reiniciamos el servicio networking y comprobamos la conectividad a las máquinas:

 ```shell
 #dulcinea a freston
 debian@francisco-madu:~$ ping 10.0.1.14
PING 10.0.1.14 (10.0.1.14) 56(84) bytes of data.
64 bytes from 10.0.1.14: icmp_seq=1 ttl=64 time=1.44 ms
64 bytes from 10.0.1.14: icmp_seq=2 ttl=64 time=0.858 ms
^C
--- 10.0.1.14 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 3ms
rtt min/avg/max/mdev = 0.858/1.146/1.435/0.290 ms

#freston a sancho
debian@freston:~$ ping 10.0.1.7
PING 10.0.1.7 (10.0.1.7) 56(84) bytes of data.
64 bytes from 10.0.1.7: icmp_seq=1 ttl=64 time=2.44 ms
64 bytes from 10.0.1.7: icmp_seq=2 ttl=64 time=0.904 ms
^C
--- 10.0.1.7 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 3ms
rtt min/avg/max/mdev = 0.904/1.671/2.438/0.767 ms

#freston a quijote
debian@freston:~$ ping 10.0.1.10
PING 10.0.1.10 (10.0.1.10) 56(84) bytes of data.
64 bytes from 10.0.1.10: icmp_seq=1 ttl=64 time=2.57 ms
64 bytes from 10.0.1.10: icmp_seq=2 ttl=64 time=0.583 ms
64 bytes from 10.0.1.10: icmp_seq=3 ttl=64 time=0.790 ms
^C
--- 10.0.1.10 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 14ms
rtt min/avg/max/mdev = 0.583/1.312/2.565/0.890 ms

#hacia internet
debian@freston:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=111 time=42.8 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=111 time=42.7 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=111 time=42.4 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=111 time=42.5 ms
^C
--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 7ms
rtt min/avg/max/mdev = 42.437/42.623/42.803/0.254 ms

```

Ahora tenemos conectado correctamente **freston** a nuestra red.

### Quijote

Para comenzar le añadimos la nueva red DMZ y le quitamos su antigua red.

Accederemos desde Horizon y modificaremos su bridge.
En /etc/sysconfig/network-scripts/ifcfg-eth0
```shell
# Created by cloud-init on instance boot automatically, do not edit.
#
DEVICE="eth0"
BOOTPROTO="static"
IPADDR="10.0.2.3"
NETMASK="255.255.255.0"
NETWORK="10.0.2.0"
GATEWAY="10.0.2.9"
ONBOOT="yes"
TYPE="Ethernet"
```

**Pruebas de conexión**

```shell
#dulcinea a quijote
debian@francisco-madu:~$ ping 10.0.2.3
PING 10.0.2.3 (10.0.2.3) 56(84) bytes of data.
64 bytes from 10.0.2.3: icmp_seq=1 ttl=64 time=2.84 ms
64 bytes from 10.0.2.3: icmp_seq=2 ttl=64 time=0.685 ms
^C
--- 10.0.2.3 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 2ms
rtt min/avg/max/mdev = 0.685/1.760/2.835/1.075 ms

#quijote dulcinea
[centos@quijote ~]$ ping 10.0.2.7
PING 10.0.2.7 (10.0.2.7) 56(84) bytes of data.
64 bytes from 10.0.2.7: icmp_seq=1 ttl=64 time=0.798 ms
64 bytes from 10.0.2.7: icmp_seq=2 ttl=64 time=0.763 ms
64 bytes from 10.0.2.7: icmp_seq=3 ttl=64 time=0.872 ms
^C
--- 10.0.2.7 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 4ms
rtt min/avg/max/mdev = 0.763/0.811/0.872/0.045 ms

#quijote sancho
[centos@quijote ~]$ ping 10.0.1.7
PING 10.0.1.7 (10.0.1.7) 56(84) bytes of data.
64 bytes from 10.0.1.7: icmp_seq=1 ttl=63 time=2.03 ms
64 bytes from 10.0.1.7: icmp_seq=2 ttl=63 time=1.25 ms
64 bytes from 10.0.1.7: icmp_seq=3 ttl=63 time=1.24 ms
^C
--- 10.0.1.7 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 4ms
rtt min/avg/max/mdev = 1.236/1.505/2.026/0.368 ms

#quijote freston
[centos@quijote ~]$ ping 10.0.1.14
PING 10.0.1.14 (10.0.1.14) 56(84) bytes of data.
64 bytes from 10.0.1.14: icmp_seq=1 ttl=63 time=1.72 ms
64 bytes from 10.0.1.14: icmp_seq=2 ttl=63 time=1.30 ms
64 bytes from 10.0.1.14: icmp_seq=3 ttl=63 time=1.14 ms
64 bytes from 10.0.1.14: icmp_seq=4 ttl=63 time=1.07 ms
^C
--- 10.0.1.14 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 8ms
rtt min/avg/max/mdev = 1.068/1.306/1.720/0.252 ms

#quijote exterior
[centos@quijote ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=111 time=500 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=111 time=462 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=111 time=504 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=111 time=480 ms
64 bytes from 8.8.8.8: icmp_seq=5 ttl=111 time=481 ms
^C
--- 8.8.8.8 ping statistics ---
6 packets transmitted, 5 received, 16.6667% packet loss, time 11ms
rtt min/avg/max/mdev = 461.839/485.497/504.446/15.432 ms
```

Añadido: Resolución estatica correcta a todas las maquinas.
```shell
# Your system has configured 'manage_etc_hosts' as True.
# As a result, if you wish for changes to this file to persist
# then you will need to either
# a.) make changes to the master file in /etc/cloud/templates/hosts.debian.tmpl
# b.) change or remove the value of 'manage_etc_hosts' in
#     /etc/cloud/cloud.cfg or cloud-config from user-data
#
127.0.1.1 dulcinea.madu.gonzalonazareno.org dulcinea.novalocal dulcinea
127.0.0.1 localhost
10.0.1.14 freston.madu.gonzalonazareno.org freston
10.0.2.12 quijote.madu.gonozalonazareno.org quijote
10.0.1.7 sancho.madu.gonzalonazareno.org sancho

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
```