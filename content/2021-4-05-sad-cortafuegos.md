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

## Política por defecto

**La política por defecto que vamos a configurar en nuestro cortafuegos será de tipo DROP.**
```shell
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
```

## NAT

* **Configura de manera adecuada las reglas NAT para que todas las máquinas de nuestra red tenga acceso al exterior.**  
```shell
iptables -t nat -A POSTROUTING -s 10.0.1.0/24 -o eth1 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o eth1 -j MASQUERADE
```

* **Configura de manera adecuada todas las reglas NAT necesarias para que los servicios expuestos al exterior sean accesibles.**  
```shell
iptables -t nat -A PREROUTING -p udp --dport 53 -i eth1 -j DNAT --to 10.0.1.3
iptables -t nat -A PREROUTING -p tcp --dport 53 -i eth1 -j DNAT --to 10.0.1.3
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 80 -j DNAT --to 10.0.2.4
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 443 -j DNAT --to 10.0.2.4
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 25 -j DNAT --to 10.0.1.3
```

## Reglas

**Para cada configuración, hay que mostrar las reglas que se han configurado y una prueba de funcionamiento de la misma:**

### ping:

* **Todas las máquinas de las dos redes pueden hacer ping entre ellas.**  
```shell
#Permitir ping Dulcinea con la red interna y la DMZ
iptables -A OUTPUT -o eth0 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -i eth0 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT

iptables -A OUTPUT -o eth2 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -i eth2 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT

#Permitir ping DMZ con la red interna
iptables -A FORWARD -i eth2 -o eth0 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT

#Permitir ping red interna con la DMZ
iptables -A FORWARD -i eth0 -o eth2 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT
```

* **Todas las máquinas pueden hacer ping a una máquina del exterior.**  
```shell
#Permitir ping red interna al exterior

iptables -A FORWARD -i eth0 -o eth1 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT

#Permitir ping DMZ al exterior

iptables -A FORWARD -i eth2 -o eth1 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A FORWARD -i eth1 -o eth2 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT
```

* **Desde el exterior se puede hacer ping a dulcinea.**  
```shell
iptables -A INPUT -i eth1 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -o eth1 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT
```

* **A dulcinea se le puede hacer ping desde la DMZ, pero desde la LAN se le debe rechazar la conexión (REJECT).**  
```shell

```


### ssh

* **Podemos acceder por ssh a todas las máquinas.**  
```shell

```

* **Todas las máquinas pueden hacer ssh a máquinas del exterior.**  
```shell

```

* **La máquina dulcinea tiene un servidor ssh escuchando por el puerto 22, pero al acceder desde el exterior habrá que conectar al puerto 2222.**  
```shell

```


### dns

* **El único dns que pueden usar los equipos de las dos redes es freston, no pueden utilizar un DNS externo.**  
```shell

```

* **dulcinea puede usar cualquier servidor DNS.**  
```shell

```

* **Tenemos que permitir consultas dns desde el exterior a freston, para que, por ejemplo, papion-dns pueda preguntar.**  
```shell

```


### Base de datos

* **A la base de datos de sancho sólo pueden acceder las máquinas de la DMZ.**  
```shell

```


### Web

* **Las páginas web de quijote (80, 443) pueden ser accedidas desde todas las máquinas de nuestra red y desde el exterior.**  
```shell

```


### Más servicios

* **Configura de manera adecuada el cortafuegos, para otros servicios que tengas instalado en tu red (ldap, correo, ...)**  
```shell

```
