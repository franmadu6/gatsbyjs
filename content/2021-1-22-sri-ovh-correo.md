---
date: 2021-01-22
title: "Práctica correo ovh"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - SRI
tags:
    - OVH
    - Servidor de Correo
    - Postfix
---

<center><img alt="Postfix" src="https://feedyourweb.com/wp-content/uploads/2017/12/Postfix_logo.png"/></center>

## Práctica: Servidor de correos

### Instala y configura de manera adecuada el servidor de correos en tu máquina de OVH, para tu dominio iesgnXX.es. El nombre del servidor de correo será mail.iesgnXX.es (Este es el nombre que deberá aparecer en el registro MX)

#### Gestión de correos desde el servidor
<hr>

* Tarea 1: Documenta una prueba de funcionamiento, donde envíes desde tu servidor local al exterior. Muestra el log donde se vea el envío. Muestra el correo que has recibido. Muestra el registro SPF.

Lo primero que debemos hacer es añadir el registro de mail.iesgn11.es en OVH.
![PracticaImg](images/servicios/ovhpostfix1.png "Imagen de la practica")

Comenzaremos la instalación de mi servidor de correos.
```shell
debian@valhalla:~$ sudo apt-get install postfix
#elegimos la opción internet site
debian@valhalla:~$ sudo apt-get install bsd-mailx
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  liblockfile-bin liblockfile1
The following NEW packages will be installed:
  bsd-mailx liblockfile-bin liblockfile1
0 upgraded, 3 newly installed, 0 to remove and 0 not upgraded.
Need to get 125 kB of archives.
After this operation, 265 kB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://deb.debian.org/debian buster/main amd64 liblockfile-bin amd64 1.14-1.1 [19.7 kB]
Get:2 http://deb.debian.org/debian buster/main amd64 liblockfile1 amd64 1.14-1.1 [16.2 kB]
Get:3 http://deb.debian.org/debian buster/main amd64 bsd-mailx amd64 8.1.2-0.20180807cvs-1 [89.2 kB]
Fetched 125 kB in 0s (2,984 kB/s)
Selecting previously unselected package liblockfile-bin.
(Reading database ... 38471 files and directories currently installed.)
Preparing to unpack .../liblockfile-bin_1.14-1.1_amd64.deb ...
Unpacking liblockfile-bin (1.14-1.1) ...
Selecting previously unselected package liblockfile1:amd64.
Preparing to unpack .../liblockfile1_1.14-1.1_amd64.deb ...
Unpacking liblockfile1:amd64 (1.14-1.1) ...
Selecting previously unselected package bsd-mailx.
Preparing to unpack .../bsd-mailx_8.1.2-0.20180807cvs-1_amd64.deb ...
Unpacking bsd-mailx (8.1.2-0.20180807cvs-1) ...
Setting up liblockfile-bin (1.14-1.1) ...
Setting up liblockfile1:amd64 (1.14-1.1) ...
Setting up bsd-mailx (8.1.2-0.20180807cvs-1) ...
update-alternatives: using /usr/bin/bsd-mailx to provide /usr/bin/mailx (mailx) in auto mode
Processing triggers for libc-bin (2.28-10) ...
Scanning processes...                                                                     
Scanning candidates...                                                                    
Scanning linux images...                                                                  

Restarting services...
 /etc/needrestart/restart.d/dbus.service
Service restarts being deferred:
 systemctl restart systemd-logind.service

No containers need to be restarted.

No user sessions are running outdated binaries.
```

Comprobamos que nos llegan correctamente los mensajes.
```shell
debian@valhalla:/etc/postfix$ echo "Test Postfix Gmail https://example.com" | mail -s "Postfix Gmail" frandh1997@gmail.com
```
![PracticaImg](images/servicios/postfix1.png "Imagen de la practica")

* Tarea 2: Documenta una prueba de funcionamiento, donde envíes un correo desde el exterior (gmail, hotmail,…) a tu servidor local. Muestra el log donde se vea el envío. Muestra cómo has leído el correo. Muestra el registro MX de tu dominio.

Enviamos un correo desde el exterior.
![PracticaImg](images/servicios/postfix2.png "Imagen de la practica")

Comprobamos que el correo nos ha llegado a nuestro servidor.
```shell
debian@valhalla:/etc/postfix$ mail
Mail version 8.1.2 01/15/2001.  Type ? for help.
"/var/mail/debian": 1 message 1 new
>N  1 frandh1997@gmail.  Fri Feb 19 08:31   54/2729  prueba de exterior
& 1
```
```shell
Message 1:
From frandh1997@gmail.com  Fri Feb 19 08:31:34 2021
X-Original-To: debian@mail.iesgn11.es
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=7+C0cH+XTwVM5FmjN4y4fvYVwc1ZS4e+T4Ju1otG9yg=;
        b=ulCrZ1cNTsJpScf7dHtkTs4JFdx8O81x8wUjyJzTQKcOd+TuAr5YfqqzdDEwnV7tRB
         vSG8D/+Iaw6HQTQXFUmmAS4t//jmJxajhhh3t1IY4KfAtTm6qdhzsDtbTjXa2YLZOkXs
         T4w5waZdJ0XXfYuMF+EjD5EPXSLzCkCmtOHGftB27vnbcK+RJvq+7AV44xH6QkRgeK65
         5jDlukoO/oeM6lTFH8dfYcjuTCTyU7fvbey9LMHDfZfWPxUFbrICLvVFsB8o2AU9hBwV
         HH0aAPt4maxmKlgnI/jC1og4dJZv4DRREW243oKetl86KmyDsizPZeNOuHuoMTne+Mg6
         2eCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=7+C0cH+XTwVM5FmjN4y4fvYVwc1ZS4e+T4Ju1otG9yg=;
        b=OGrxETX5B41pr8sOB++d7pOBRyeas/5N1a6jBHcIa6RDuEfBRW00asBBpL4QzFx4eQ
         PV7DdPefo0RDa0gW6G1CJKm4Y85dOFbC5BiN+HDr8eUANGMtOrwytc/9UVuvtYmhK4zQ
         XDmPezRg4rA0ZcQX/395/LQU1kWFOk3mNXKxk5mj086RWrxiljgqLBXRy/+oTsXhzfX1
         V6KG1SveD2PZ2RODzKSonVQYJXXygHIKZCloNE5M57McrFURLHwUJwX+us/+7bkjNLNO
         ulZC9Zr+fVRyeI8rXoscRYIuOhxJxOcCY5YtO09k/+hExypDVhfYVfC4dDX/d9fggKUJ
         r4VQ==
X-Gm-Message-State: AOAM5303+pF0t16X/bq7L2RVnWYD4dVlwQABBdOHoHE3WSeMSKkFjz/k
        TD1IkQqCPtwThfxH6QD2TH2jU+euHUGUd0tPPci+x0UrnuA=
X-Google-Smtp-Source: ABdhPJz2btPq6mNNIYNK26TNxCqxcTCyCB6u4fLbotd7ot+9delF8K/6/pmqpx9vcivuWAx+jTx1i0G+yr1/HJyYzMA=
X-Received: by 2002:a05:6402:617:: with SMTP id n23mr8212851edv.257.1613723493573;
 Fri, 19 Feb 2021 00:31:33 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?Q?Fran_Madue=C3=B1o?= <frandh1997@gmail.com>
Date: Fri, 19 Feb 2021 09:31:22 +0100
Subject: prueba de exterior
To: debian@mail.iesgn11.es
Content-Type: multipart/alternative; boundary="00000000000099a8fa05bbac4798"

--00000000000099a8fa05bbac4798
Content-Type: text/plain; charset="UTF-8"

realizando prueba desde el exterior

:
```

#### Uso de alias y redirecciones
<hr>

* Tarea 3 (No obligatoria): Uso de alias y redirecciones.

Para esta tarea voy a crear una tarea que cada minuto envie un mail con información desde cron.
```shell
debian@valhalla:~$ crontab -e
MAILTO = root
* * * * * date
```

Tras esperar unos minutos comprobaremos el resultado.
```shell
debian@valhalla:~$ mail
Mail version 8.1.2 01/15/2001.  Type ? for help.
"/var/mail/debian": 9 messages 1 new 9 unread
 U  1 root@iesgn11.es    Sat Feb 20 13:48   23/726   Cron <debian@valhalla> date
 U  2 root@iesgn11.es    Sat Feb 20 13:49   23/726   Cron <debian@valhalla> date
 Message 1:
From debian@iesgn11.es  Sat Feb 20 13:48:01 2021
X-Original-To: root
From: root@iesgn11.es (Cron Daemon)
To: root@iesgn11.es
Subject: Cron <debian@valhalla> date
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Cron-Env: <MAILTO=root>
X-Cron-Env: <SHELL=/bin/sh>
X-Cron-Env: <HOME=/home/debian>
X-Cron-Env: <PATH=/usr/bin:/bin>
X-Cron-Env: <LOGNAME=debian>
Date: Sat, 20 Feb 2021 13:48:01 +0000 (UTC)

Sat 20 Feb 2021 01:48:01 PM UTC
```

#### Para asegurar el envío
<hr>

* Tarea 4 (No obligatoria): Configura de manera adecuada DKIM es tu sistema de correos. Comprueba el registro DKIM en la página https://mxtoolbox.com/dkim.aspx. Configura postfix para que firme los correos que envía. Manda un correo y comprueba la verificación de las firmas en ellos.

```shell

```

#### Para luchar contra el SPAM
<hr>

* Tarea 5 (No obligatorio): Configura de manera adecuada Postfix para que tenga en cuenta el registro SPF de los correos que recibe. Muestra el log del correo para comprobar que se está haciendo el testeo del registro SPF.

* Tarea 6 (No obligatoria): Configura un sistema antispam. Realiza comprobaciones para comprobarlo.

* Tarea 7 (No obligatoria): Configura un sistema antivirus. Realiza comprobaciones para comprobarlo.


#### Gestión de correos desde un cliente
<hr>

* Tarea 8: Configura el buzón de los usuarios de tipo Maildir. Envía un correo a tu usuario y comprueba que el correo se ha guardado en el buzón Maildir del usuario del sistema correspondiente. Recuerda que ese tipo de buzón no se puede leer con la utilidad mail.

Añadimos la directiva home_mailbox en main.cf
```shell
debian@valhalla:~$ sudo nano /etc/postfix/main.cf
home_mailbox = Maildir/
```

Reiniciamos el servicio.
```shell
debian@valhalla:~$ sudo systemctl restart postfix
```

Para poder tendremos que instalar una nueva herramienta para leer los archivos recividos en nuestro caso instalaremos mutt, que será nuestro cliente de correos para la terminal.
```shell
debian@valhalla:~$ sudo apt install mutt
```

Tendremos que configurarlo ya que por defecto no se encuentra configurado para que busque mensajes de correo dentro del directorio que hemos creado anteriormente.
```shell
debian@valhalla:~$ sudo nano ~/.muttrc
set mbox_type=Maildir
set folder="~/Maildir"
set mask="!^\\.[^.]"
set mbox="~/Maildir"
set record="+.Sent"
set postponed="+.Drafts"
set spoolfile="~/Maildir"
```

Nos enviaremos un correo desde el exterior para que se realice la configuración que hemos hecho anteriormente.
```shell
debian@valhalla:~$ ls -l Maildir/new/
total 8
-rw------- 1 debian debian 4179 Feb 22 13:19 1613999957.V801I81f9eM140605.valhalla.iesgn11.es
debian@valhalla:~$ mutt
1 kept, 0 deleted.
```
![PracticaImg](images/servicios/mutt1.png "Imagen de la practica")

* Tarea 9: Instala configura dovecot para ofrecer el protocolo IMAP. Configura dovecot de manera adecuada para ofrecer autentificación y cifrado.

Modificamos el registro SPF de OVH.
![PracticaImg](images/servicios/ovhpostfix2.png "Imagen de la practica")

### Recepción

Instalamos Dovecot.
```shell
root@valhalla:/home/debian# apt install dovecot-imapd
```

Creamos claves ssl para Dovecot.
```shell
root@valhalla:/home/debian# systemctl stop nginx
root@valhalla:/home/debian# certbot certonly --standalone -d mail.iesgn11.es
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator standalone, Installer None
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for mail.iesgn11.es
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/mail.iesgn11.es/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/mail.iesgn11.es/privkey.pem
   Your cert will expire on 2021-05-21. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le

root@valhalla:/home/debian# systemctl start nginx
```

Modificamos las directivas ssl_cert y ssl_key y añadimos sus respectivos directorios.
```shell
root@valhalla:/home/debian# nano /etc/dovecot/conf.d/10-ssl.conf
ssl_cert = </etc/letsencrypt/live/mail.iesgn11.es/fullchain.pem
ssl_key = </etc/letsencrypt/live/mail.iesgn11.es/privkey.pem
```

Modificamos la directiva mail_location para que este haciendo uso de buzones tipo Maildir.
```shell
root@valhalla:/home/debian# nano /etc/dovecot/conf.d/10-mail.conf
mail_location = maildir:~/Maildir
```

Reiniciamos servicio.
```shell
root@valhalla:/home/debian# systemctl restart dovecot
```

<hr>

### Envio

Modificamos main.cf y añadimos las directivas necesarias para un correcto funcionamiento de dovecot.
```shell
debian@valhalla:~$ sudo nano /etc/postfix/main.cf
# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

smtpd_sasl_auth_enable = yes
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_authenticated_header = yes
broken_sasl_auth_clients = yes
```

Descomentaremos las directivas smtps y submission, del fichero master.cf
```shell
debian@valhalla:~$ sudo nano /etc/postfix/master.cf
submission inet n       -       y       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_security_level=encrypt
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_tls_auth_only=yes
  -o smtpd_reject_unlisted_recipient=no
  -o smtpd_client_restrictions=$mua_client_restrictions
  -o smtpd_helo_restrictions=$mua_helo_restrictions
  -o smtpd_sender_restrictions=$mua_sender_restrictions
  -o smtpd_recipient_restrictions=
  -o smtpd_relay_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING
smtps     inet  n       -       y       -       -       smtpd
  -o syslog_name=postfix/smtps
  -o smtpd_tls_wrappermode=yes
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_reject_unlisted_recipient=no
  -o smtpd_client_restrictions=$mua_client_restrictions
  -o smtpd_helo_restrictions=$mua_helo_restrictions
  -o smtpd_sender_restrictions=$mua_sender_restrictions
  -o smtpd_recipient_restrictions=
  -o smtpd_relay_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING
```

Modificaremos el siguiente fichero para conectar los servicios dovecot y postfix.
```shell
debian@valhalla:~$ sudo nano /etc/dovecot/conf.d/10-master.conf
unix_listener /var/spool/postfix/private/auth {
  mode = 0666
}
```

Reiniciamos servicios.
```shell
debian@valhalla:~$ sudo systemctl restart postfix dovecot
```

Comprobación
```shell
debian@valhalla:~$ netstat -tln
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 0.0.0.0:143             0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:465             0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:25              0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:443             0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:993             0.0.0.0:*               LISTEN     
tcp        0      0 127.0.1.1:3306          0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:587             0.0.0.0:*               LISTEN     
tcp6       0      0 :::143                  :::*                    LISTEN     
tcp6       0      0 :::80                   :::*                    LISTEN     
tcp6       0      0 :::465                  :::*                    LISTEN     
tcp6       0      0 :::22                   :::*                    LISTEN     
tcp6       0      0 :::25                   :::*                    LISTEN     
tcp6       0      0 :::443                  :::*                    LISTEN     
tcp6       0      0 :::993                  :::*                    LISTEN     
tcp6       0      0 :::587                  :::*                    LISTEN     
```

Como podemos ver tanto el puerto 587 como el 465 se encuentran escuchando peticiones.

<hr>

### Cliente

Configuramos una cuenta en thunderbird
![PracticaImg](images/servicios/cuentatb1.png "Imagen de la practica")

Enviamos un correo desde thunderbird hacia Gmail.
![PracticaImg](images/servicios/tb1.png "Imagen de la practica")

Recibimos respuesta.
![PracticaImg](images/servicios/pruebatb1.png "Imagen de la practica")

* Tarea 10 (No obligatoria): Instala un webmail (roundcube, horde, rainloop) para gestionar el correo del equipo mediante una interfaz web. Muestra la configuración necesaria y cómo eres capaz de leer los correos que recibe tu usuario.

## Creamos BBDD para Roundcube.
```shell
debian@valhalla:~$ sudo mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 36
Server version: 10.3.27-MariaDB-0+deb10u1 Debian 10

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> create database roundcube;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON roundcube.* TO roundcube@"localhost" IDENTIFIED BY 'fran';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> 
```

```shell
sudo apt-get install php php-cli php-gd php-intl php-fpm php-curl php-imagick php-mysql php-zip php-xml php-mbstring php-bcmath -y
```

```shell
root@valhalla:/# sed -i 's/;date.timezone =/date.timezone = Europe\/Madrid/g' /etc/php/7.3/fpm/php.ini
root@valhalla:/# sudo systemctl restart php7.3-fpm
```

## Descargamos Roundcube.
```shell
debian@valhalla:~$ sudo wget https://github.com/roundcube/roundcubemail/releases/download/1.4.8/roundcubemail-1.4.8-complete.tar.gz -P /var/www/html/
--2021-02-19 11:17:35--  https://github.com/roundcube/roundcubemail/releases/download/1.4.8/roundcubemail-1.4.8-complete.tar.gz
Resolving github.com (github.com)... 140.82.121.4
Connecting to github.com (github.com)|140.82.121.4|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://github-releases.githubusercontent.com/4224042/1c2f9080-db4f-11ea-9a6f-6772c69cb02b?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20210219%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210219T111735Z&X-Amz-Expires=300&X-Amz-Signature=7dcfae9a6b888dfd038dcafb033ab8ff51e5dcbc19fc2f2f80d4e148810ace85&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=4224042&response-content-disposition=attachment%3B%20filename%3Droundcubemail-1.4.8-complete.tar.gz&response-content-type=application%2Foctet-stream [following]
--2021-02-19 11:17:35--  https://github-releases.githubusercontent.com/4224042/1c2f9080-db4f-11ea-9a6f-6772c69cb02b?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20210219%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210219T111735Z&X-Amz-Expires=300&X-Amz-Signature=7dcfae9a6b888dfd038dcafb033ab8ff51e5dcbc19fc2f2f80d4e148810ace85&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=4224042&response-content-disposition=attachment%3B%20filename%3Droundcubemail-1.4.8-complete.tar.gz&response-content-type=application%2Foctet-stream
Resolving github-releases.githubusercontent.com (github-releases.githubusercontent.com)... 185.199.110.154, 185.199.109.154, 185.199.111.154, ...
Connecting to github-releases.githubusercontent.com (github-releases.githubusercontent.com)|185.199.110.154|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 7032822 (6.7M) [application/octet-stream]
Saving to: ‘/var/www/html/roundcubemail-1.4.8-complete.tar.gz’

roundcubemail-1.4.8-c 100%[=======================>]   6.71M  20.2MB/s    in 0.3s    

2021-02-19 11:17:35 (20.2 MB/s) - ‘/var/www/html/roundcubemail-1.4.8-complete.tar.gz’ saved [7032822/7032822]
```

```shell
debian@valhalla:~$ sudo tar zxvf /var/www/html/roundcubemail-1.4.8-complete.tar.gz -C /var/www/

debian@valhalla:~$ sudo mv /var/www/html/roundcubemail-1.4.8 /var/www//roundcube

debian@valhalla:~$ sudo chown www-data:www-data -R /var/www/roundcube
```

Crearemos una zona virtual en nginx para poderes visualizarlo.
```shell
root@valhalla:/etc/nginx/sites-available# cat roundcube.iesgn11 
server {
        listen 80;
        listen [::]:80;

        server_name roundcube.iesgn11.es;

        return 301 https://$host$request_uri;
}

server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        ssl    on;
        ssl_certificate    /etc/letsencrypt/live/portal.iesgn11.es/fullchain.pem;
        ssl_certificate_key    /etc/letsencrypt/live/portal.iesgn11.es/privkey.pem;

         root /var/www/roundcube;
        
	index index.php index.html;
        
	server_name roundcube.iesgn11.es;
        
	location / {
		try_files $uri @rewrite;
        }

	location @rewrite {
                rewrite ^/(.*)$ /index.php?q=$1;
        }

        location ~ \.php(?:$|/) {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param HTTPS on;
        fastcgi_param modHeadersAvailable true;
        fastcgi_pass unix:/run/php/php7.3-fpm.sock;
        fastcgi_intercept_errors on;
        fastcgi_buffers 4 256k;
        fastcgi_busy_buffers_size 256k;
        }
}
```

Añadimos un registro cname en OVH.
![PracticaImg](images/servicios/roundcube1.png "Imagen de la practica")

## Instalamos Rouncube.

![PracticaImg](images/servicios/roundcube2.png "Imagen de la practica")
![PracticaImg](images/servicios/roundcube3.png "Imagen de la practica")

Borramos el instalador que es innecesario.
```shell
root@valhalla:/var/www/html/roundcubemail# rm -fr /var/www/html/roundcubemail/installer/
```

![PracticaImg](images/servicios/roundcube4.png "Imagen de la practica")

El user es "debian"

![PracticaImg](images/servicios/roundcube5.png "Imagen de la practica")


* Tarea 11: Configura de manera adecuada postfix para que podamos mandar un correo desde un cliente remoto. La conexión entre cliente y servidor debe estar autentificada con SASL usando dovecor y además debe estar cifrada. Para cifrar esta comunicación puedes usar dos opciones:


    * ESMTP + STARTTLS: Usando el puerto 567/tcp enviamos de forma segura el correo al servidor.
    * SMTPS: Utiliza un puerto no estándar (465) para SMTPS (Simple Mail Transfer Protocol Secure). No es una extensión de smtp. Es muy parecido a HTTPS.

Elige una de las opciones anterior para realizar el cifrado. Y muestra la configuración de un cliente de correo (evolution, thunderbird, …) y muestra como puedes enviar los correos.


Tarea realizada con la **Tarea 9**.


* Tarea 12 (No obligatoria): Configura el cliente webmail para el envío de correo. Realiza una prueba de envío con el webmail.

Despues de instalar Roundcube podia recibir correos pero me salia el siguiente error:
```shell
Error SMTP (250): Ha fallado la autenticación.
```

Lo solucione modificando el smtp_server de localhost a tls://roundcube.iesgn11.es:
```shell
debian@valhalla:~$ sudo nano /var/www/roundcube/config/config.inc.php
$config['smtp_server'] = 'tls://roundcube.iesgn11.es';
```
![PracticaImg](images/servicios/roundcube6.png "Imagen de la practica")
![PracticaImg](images/servicios/roundcube7.png "Imagen de la practica")

#### Comprobación final
<hr>

* Tarea 13 (No obligatoria): Prueba de envío de correo. En esta página tenemos una herramienta completa y fácil de usar a la que podemos enviar un correo para que verifique y puntúe el correo que enviamos. Captura la pantalla y muestra la puntuación que has sacado.

https://www.mail-tester.com/

Deberemos copiar el correo que nos muestra por pantalla y enviarle un mensaje para que haga una calificación.
![PracticaImg](images/servicios/pruebafinal1.png "Imagen de la practica")

