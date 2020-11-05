---
date: 2020-10-20
title: "Práctica 2: Cifrado asimétrico con gpg y openssl"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - Seguridad
tags:
    - GPG
    - OpenSSL
---

## Tarea 1: Generación de claves

* Genera un par de claves (pública y privada). ¿En que directorio se guarda las claves de un usuario?

**Generar par de claves**
```shell
fran@debian:~$ gpg --gen-key
gpg (GnuPG) 2.2.12; Copyright (C) 2018 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Nota: Usa "gpg --full-generate-key" para el diálogo completo de generación de clave.

GnuPG debe construir un ID de usuario para identificar su clave.

Nombre y apellidos: Francisco Javier Madueño Jurado
Dirección de correo electrónico: frandh1997@gmail.com
Está usando el juego de caracteres 'utf-8'.
Ha seleccionado este ID de usuario:
    "Francisco Javier Madueño Jurado <frandh1997@gmail.com>"

¿Cambia (N)ombre, (D)irección o (V)ale/(S)alir? v
Es necesario generar muchos bytes aleatorios. Es una buena idea realizar
alguna otra tarea (trabajar en otra ventana/consola, mover el ratón, usar
la red y los discos) durante la generación de números primos. Esto da al
generador de números aleatorios mayor oportunidad de recoger suficiente
entropía.
Es necesario generar muchos bytes aleatorios. Es una buena idea realizar
alguna otra tarea (trabajar en otra ventana/consola, mover el ratón, usar
la red y los discos) durante la generación de números primos. Esto da al
generador de números aleatorios mayor oportunidad de recoger suficiente
entropía.
gpg: clave 57112B319F2A6170 marcada como de confianza absoluta
gpg: creado el directorio '/home/fran/.gnupg/openpgp-revocs.d'
gpg: certificado de revocación guardado como '/home/fran/.gnupg/openpgp-revocs.d/28ED3C3112ED8846BEDFFAF657112B319F2A6170.rev'
claves pública y secreta creadas y firmadas.

pub   rsa3072 2020-10-06 [SC] [caduca: 2022-10-06]
      28ED3C3112ED8846BEDFFAF657112B319F2A6170
uid                      Francisco Javier Madueño Jurado <frandh1997@gmail.com>
sub   rsa3072 2020-10-06 [E] [caduca: 2022-10-06]
```
Como podemos ver en la salida nuestra clave se guarda en /home/fran/.gnupg/openpgp-revocs.d

* Lista las claves públicas que tienes en tu almacén de claves. Explica los distintos datos que nos muestra. ¿Cómo deberías haber generado las claves para indicar, por ejemplo, que tenga un 1 mes de validez?
```shell
fran@debian:~/Cifrado$ gpg --list-key
/home/fran/.gnupg/pubring.kbx
-----------------------------
pub   rsa3072 2020-10-06 [SC] [caduca: 2022-10-06]
      28ED3C3112ED8846BEDFFAF657112B319F2A6170
uid        [  absoluta ] Francisco Javier Madueño Jurado <frandh1997@gmail.com>
sub   rsa3072 2020-10-06 [E] [caduca: 2022-10-06]
pub   rsa3072 2020-10-06 [SC] [caduca: 2022-10-06]
      9233303D1F5495739A6D2CB4636AE9EBCB7E3294
uid        [desconocida] Manuel Lora Román <manuelloraroman@gmail.com>
sub   rsa3072 2020-10-06 [E] [caduca: 2022-10-06]
pub   rsa3072 2020-10-08 [SC] [caduca: 2020-11-07]
      443D661D9AAF3ABAEDCA93E1C3B291882C4EE5DF
uid        [desconocida] Alejandro Gutierrez Valencia <tojandro@gmail.com>
sub   rsa3072 2020-10-08 [E] [caduca: 2020-11-07]
```
Nos muestra el nombre de la persona, su correo, cuando se genero la clave, cuando caduca y el código de la clave.  

* Lista las claves privadas de tu almacén de claves
```shell
fran@debian:~/Cifrado$ gpg --list-secret-keys
/home/fran/.gnupg/pubring.kbx
-----------------------------
sec   rsa3072 2020-10-06 [SC] [caduca: 2022-10-06]
      28ED3C3112ED8846BEDFFAF657112B319F2A6170
uid        [  absoluta ] Francisco Javier Madueño Jurado <frandh1997@gmail.com>
ssb   rsa3072 2020-10-06 [E] [caduca: 2022-10-06]
```

## Tarea 2: Importar / exportar clave pública (1 punto)

* Exporta tu clave pública en formato ASCII y guardalo en un archivo nombre_apellido.asc y envíalo al compañero con el que vas a hacer esta práctica.
```shell
fran@debian:~/Cifrado$ gpg --export -a fran > fran_madueño.asc
```

* Importa las claves públicas recibidas de vuestro compañero.
```shell
fran@debian:~/Cifrado$ gpg --import alejandro_gutierrez.asc 
```

* Comprueba que las claves se han incluido correctamente en vuestro keyring.
```shell
fran@debian:~/Cifrado$ gpg --list-key
/home/fran/.gnupg/pubring.kbx
-----------------------------
pub   rsa3072 2020-10-06 [SC] [caduca: 2022-10-06]
      28ED3C3112ED8846BEDFFAF657112B319F2A6170
uid        [  absoluta ] Francisco Javier Madueño Jurado <frandh1997@gmail.com>
sub   rsa3072 2020-10-06 [E] [caduca: 2022-10-06]

pub   rsa3072 2020-10-06 [SC] [caduca: 2022-10-06]
      9233303D1F5495739A6D2CB4636AE9EBCB7E3294
uid        [desconocida] Manuel Lora Román <manuelloraroman@gmail.com>
sub   rsa3072 2020-10-06 [E] [caduca: 2022-10-06]

pub   rsa3072 2020-10-08 [SC] [caduca: 2020-11-07]
      443D661D9AAF3ABAEDCA93E1C3B291882C4EE5DF
uid        [desconocida] Alejandro Gutierrez Valencia <tojandro@gmail.com>
sub   rsa3072 2020-10-08 [E] [caduca: 2020-11-07]
```

## Tarea 3: Cifrado asimétrico con claves públicas (3 puntos)

* Cifraremos un archivo cualquiera y lo remitiremos por email a uno de nuestros compañeros que nos proporcionó su clave pública.
```shell
fran@debian:~/Cifrado$ gpg -er 9233303D1F5495739A6D2CB4636AE9EBCB7E3294 kpasa 
```

* Nuestro compañero, a su vez, nos remitirá un archivo cifrado para que nosotros lo descifremos.
```shell
root@debian:/home/fran/Cifrado# gpg -o pruebagpg -d pruebagpg.gpg
root@debian:/home/fran/Cifrado# cat pruebagpg
root@debian:/home/fran/Cifrado# se ve
```
* Tanto nosotros como nuestro compañero comprobaremos que hemos podido descifrar los mensajes recibidos respectivamente.


* Por último, enviaremos el documento cifrado a alguien que no estaba en la lista de destinatarios y comprobaremos que este usuario no podrá descifrar este archivo.  
No vera el archivo, puesto que no tiene añadida nuestra clave publica a su anillo de confianza.

* Para terminar, indica los comandos necesarios para borrar las claves públicas y privadas que posees.
```shell
#borrar clave publica
gpg --delete-key "Nombre de Usuario"

#borrar clave privada
gpg --delete-secret-key "Nombre de Usuario"
```

## Tarea 4: Exportar clave a un servidor público de claves PGP (2 puntos)

* Genera la clave de revocación de tu clave pública para utilizarla en caso de que haya problemas.
```shell
#el codigo para generar una clave de revocacion es:
gpg -a --output cert-revocacion.txt --gen-revoke XXXXXXXX
# la opción -a es opcional, para generar el certificado en ascii, para poder guardarlo en un gestor de contraseñas, por ejemplo
#XXXXXXXX puede ser el identificador de clave pública o el de la clave privada, ambos identifican el par de claves que se revocaría el certificado.

#en mi caso se generaron desde un principio si miramos al principio de la configuracion
gpg: clave 57112B319F2A6170 marcada como de confianza absoluta
gpg: creado el directorio '/home/fran/.gnupg/openpgp-revocs.d'
gpg: certificado de revocación guardado como '/home/fran/.gnupg/openpgp-revocs.d/28ED3C3112ED8846BEDFFAF657112B319F2A6170.rev'
```


* Exporta tu clave pública al servidor pgp.rediris.es
```shell
#Exportar claves a usuarios en formato binario
gpg --output clave-publica.gpg --export CB7E3294
#Exportarla al servidor de claves
gpg --send-keys --keyserver pgp.rediris.es CB7E3294
#Recivir una clave del servidor de claves
gpg  --keyserver pgp.rediris.es --recv CB7E3294
```

* Borra la clave pública de alguno de tus compañeros de clase e impórtala ahora del servidor público de rediris.
```shell
fran@debian:~$ gpg --delete-key "tojandro@gmail.com"
gpg (GnuPG) 2.2.12; Copyright (C) 2018 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.


pub  rsa3072/C3B291882C4EE5DF 2020-10-08 Alejandro Gutierrez Valencia <tojandro@gmail.com>

¿Eliminar esta clave del anillo? (s/N) s
```

## Tarea 5: Cifrado asimétrico con openssl (3 puntos)

* Genera un par de claves (pública y privada).
```shell
fran@debian:~/Cifrado$ sudo openssl genrsa -out claveOpenSSL.pem 2048
```

* Envía tu clave pública a un compañero.
```shell
fran@debian:~/Cifrado$ openssl rsa -in claveOpenSSL.pem -pubout -out ClaveOpenSSL.public.pem
```

* Utilizando la clave pública cifra un fichero de texto y envíalo a tu compañero.
```shell
#cifrado con la clave publica que mi compañero me ha pasado.
openssl rsautl -pubin -encrypt -in test1.txt -out test1.txt.enc -inkey key.publicLoraOpenSSL.pem 
```

* Tu compañero te ha mandado un fichero cifrado, muestra el proceso para el descifrado.
```shell
root@debian:/home/fran/Cifrado# openssl rsautl -decrypt -inkey claveOpenSSL.pem -in test2.txt.enc -out test2.txt
root@debian:/home/fran/Cifrado# cat test2.txt
si ves esto esta bien.
```