---
date: 2020-11-02
title: "Ejercicio 5: Control de acceso, autentificación y autorización"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - Servicios
tags:
  - Control de acceso
  - Autentificación
  - Autorización
---

### Crea un escenario en Vagrant o reutiliza uno de los que tienes en ejercicios anteriores, que tenga un servidor con una red publica, y una privada y un cliente conectada a la red privada. Crea un host virtual departamentos.iesgn.org.

* Escenario:
<pre style="background-color:powderblue;">
Vagrant.configure("2") do |config|

        config.vm.define :servidor do |servidor|
                servidor.vm.box = "debian/buster64"
                servidor.vm.hostname = "servidor"
                servidor.vm.network :public_network,:bridge=>"wlo1"
                servidor.vm.network :private_network, ip: "192.168.100.25", virtualbox__intnet: "redinterna"
        end

        config.vm.define :cliente do |cliente|
                cliente.vm.box = "debian/buster64"
                cliente.vm.hostname = "cliente"
                cliente.vm.network :private_network, ip: "192.168.100.26", virtualbox__intnet: "redinterna"
        end
end
</pre>

## A la URL departamentos.iesgn.org/intranet sólo se debe tener acceso desde el cliente de la red local, y no se pueda acceder desde la anfitriona por la red pública. A la URL departamentos.iesgn.org/internet, sin embargo, sólo se debe tener acceso desde la anfitriona por la red pública, y no desde la red local.

1. Intalaremos Apache en nuestro servidor
2. Crearemos un fichero llamado departamentos.conf ubicado en sites-avaliable
<pre style="background-color:powderblue;">
<Directory /var/www/departamentos/internet/>
                Options Indexes FollowSymLinks MultiViews
                <RequireAll>
                        Require not ip 192.168.100
                        Require all granted
                </RequireAll>
</Directory>
</pre>

## Autentificación básica. Limita el acceso a la URL departamentos.iesgn.org/secreto. Comprueba las cabeceras de los mensajes HTTP que se intercambian entre el servidor y el cliente. ¿Cómo se manda la contraseña entre el cliente y el servidor?. Entrega una breve explicación del ejercicio.

## Cómo hemos visto la autentificación básica no es segura, modifica la autentificación para que sea del tipo digest, y sólo sea accesible a los usuarios pertenecientes al grupo directivos. Comprueba las cabeceras de los mensajes HTTP que se intercambian entre el servidor y el cliente. ¿Cómo funciona esta autentificación?

## Vamos a combinar el control de acceso (ejercicio 1) y la autentificación (Ejercicios 2 y 3), y vamos a configurar el virtual host para que se comporte de la siguiente manera: el acceso a la URL departamentos.iesgn.org/secreto se hace forma directa desde la intranet, desde la red pública te pide la autentificación. Muestra el resultado al profesor.

