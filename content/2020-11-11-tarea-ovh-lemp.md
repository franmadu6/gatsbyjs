---
date: 2020-11-11
title: "Tarea OVH. Lemp"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - Servicios
tags:
    - OVH
    - Lemp
---

## Configuración inicial de OVH

Añadir clave del profesor
```shell
gpg  --keyserver pgp.rediris.es --recv 4CB31DE5

#añadir a .ssh/authorized_keys

```

Resolución de nombres
```shell
#en /etc/hostname
valhalla.iesgn11.es
#en /etc/hosts
127.0.1.1       valhalla.iesgn11.es
```
Reiniciamos la maquina.

Accedemos y verificamos su nombre:
```shell
debian@valhalla:~$ hostname -f
valhalla.iesgn11.es
```

Añadimos registro de tipo A en la zona DNS de mi dominio.
![PracticaImg](images/servicios/ovhdns.png "Imagen de la practica")
![PracticaImg](images/servicios/ovhdns2.png "Imagen de la practica")

## Instalación de un servidor LEMP (Servicios)

1. Instala un servidor web nginx
```shell
root@valhalla:/home/debian# apt-get install nginx
```
2. Instala un servidor de base de datos MariaDB. Ejecuta el programa necesario para asegurar el servicio, ya que lo vamos a tener corriendo en el entorno de producción.

```shell
root@valhalla:/home/debian# apt-get apt-get install mariadb-server
root@valhalla:/home/debian# mysql_secure_installation

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

Set root password? [Y/n] y

New password: root
Re-enter new password: root
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] y
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```

3. Instala un servidor de aplicaciones php php-fpm.

```shell
root@valhalla:/home/debian# apt-get install php php-fpm
```

4. Crea un virtualhost al que vamos acceder con el nombre www.iesgnXX.es. Recuerda que tendrás que crear un registro CNAME en la zona DNS.

5. Cuando se acceda al virtualhost por defecto default nos tiene que redirigir al virtualhost que hemos creado en el punto anterior.

6. Cuando se acceda a www.iesgnXX.es se nos redigirá a la página www.iesgnXX.es/principal

7. En la página www.iesgnXX.es/principal se debe mostrar una página web estática (utiliza alguna plantilla para que tenga hoja de estilo). En esta página debe aparecer tu nombre, y una lista de enlaces a las aplicaciones que vamos a ir desplegando posteriormente.

8. Configura el nuevo virtualhost, para que pueda ejecutar PHP. Determina que configuración tiene por defecto php-fpm (socket unix o socket TCP) para configurar nginx de forma adecuada.

9. Crea un fichero info.php que demuestre que está funcionando el servidor LEMP.

Documenta de la forma más precisa posible cada uno de los pasos que has dado, y entrega pruebas de funcionamiento para comprobar el proceso que has realizado.