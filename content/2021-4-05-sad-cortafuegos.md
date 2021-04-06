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
```shell
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
```

**La política por defecto que vamos a configurar en nuestro cortafuegos será de tipo DROP.**
```shell

```

## NAT

* **Configura de manera adecuada las reglas NAT para que todas las máquinas de nuestra red tenga acceso al exterior.**
```shell

```

* **Configura de manera adecuada todas las reglas NAT necesarias para que los servicios expuestos al exterior sean accesibles.**
```shell

```

## Reglas

**Para cada configuración, hay que mostrar las reglas que se han configurado y una prueba de funcionamiento de la misma:**

### ping:

* **Todas las máquinas de las dos redes pueden hacer ping entre ellas.**
```shell

```

* **Todas las máquinas pueden hacer ping a una máquina del exterior.**
```shell

```

* **Desde el exterior se puede hacer ping a dulcinea.**
```shell

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
