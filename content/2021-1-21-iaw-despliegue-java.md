---
date: 2021-01-21
title: "Despliegue de CMS java"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - IAW
tags:
    - CMS
    - JAVA
    - GUACAMOLE
---

<center><img alt="Guacamole" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAA14R3Xh139iog_yTHZ-e_okq_DS4AX0hOQ&usqp=CAU"/></center>

### En esta práctica vamos a desplegar un CMS escrito en java. Puedes escoger la aplicación que vas a desplegar de CMS escritos en Java o de Aplicaciones Java en Bitnami.

1. **Indica la aplicación escogida y su funcionalidad.**

2. **Escribe una guía de los pasas fundamentales para realizar la instalación.**

3. **¿Has necesitado instalar alguna librería?¿Has necesitado instalar un conector de una base de datos?**

4. **Entrega una captura de pantalla donde se vea la aplicación funcionando.**

5. **Realiza la configuración necesaria en apache2 y tomcat (utilizando el protocolo AJP) para que la aplicación sea servida por el servidor web.**

6. **Entrega una captura de pantalla donde se vea la aplicación funcionando servida por apache2.**

-------------------------------------------------------
## GUACAMOLE



<hr>

**Instalación de la paqueteria necesaria.**
```shell
root@guacamole:~# apt-get install tomcat9 && apt-get install apache2
root@guacamole:~# apt-get install libcairo2-dev libjpeg62-turbo-dev libpng-dev libossp-uuid-dev libtool
root@guacamole:~# wget http://archive.apache.org/dist/guacamole/1.2.0/source/guacamole-server-1.2.0.tar.gz
root@guacamole:~# wget http://archive.apache.org/dist/guacamole/1.2.0/binary/guacamole-1.2.0.war
```

**Descomprimimos el archivo de guacamole-server y procedemos al montaje.**
```shell
root@guacamole:~# tar -xvf guacamole-server-1.2.0.tar.gz
root@guacamole:~# cd guacamole-server-1.2.0
root@guacamole:/home/vagrant/guacamole-server-1.2.0# ./configure --with-init-dir=/etc/init.d
root@guacamole:/home/vagrant/guacamole-server-1.2.0# make
root@guacamole:/home/vagrant/guacamole-server-1.2.0# make install
root@guacamole:/home/vagrant/guacamole-server-1.2.0# ldconfig
```

**Reinicio de sistemas**
```shell
root@guacamole:/home/vagrant/guacamole-server-1.2.0# systemctl daemon-reload
root@guacamole:/home/vagrant/guacamole-server-1.2.0# systemctl start guacd
root@guacamole:/home/vagrant/guacamole-server-1.2.0# systemctl enable guacd
guacd.service is not a native service, redirecting to systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable guacd
```

**Configuración**
```shell
root@guacamole:/home/vagrant# mv guacamole-1.2.0.war /var/lib/tomcat9/webapps/guacamole.war
root@guacamole:/home/vagrant# systemctl restart tomcat9 guacd
root@guacamole:/home/vagrant# mkdir /etc/guacamole
root@guacamole:/home/vagrant# nano  /etc/guacamole/guacamole.properties
#
guacd-hostname: localhost
guacd-port:     4822
auth-provider: net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
basic-user-mapping: /etc/guacamole/user-mapping.xml
#
root@guacamole:/home/vagrant# nano /etc/guacamole/user-mapping.xml
#
<user-mapping>
    <authorize
            username="fran"
            password="2c20cb5558626540a1704b1fe524ea9a"
            encoding="md5">
        
        <connection name="SSH">
            <protocol>vnc</protocol>
            <param name="hostname">192.168.100.17</param>
            <param name="port">22</param>
            <param name="username">vagrant</param>
            <param name="password">fran</param>
        </connection>
    </authorize>

</user-mapping>
#
root@guacamole:/home/vagrant# systemctl restart tomcat9 guacd
```

En **Apache2**:
```shell
root@guacamole:/home/vagrant# a2enmod proxy proxy_http headers proxy_wstunnel
root@guacamole:/home/vagrant# nano /etc/apache2/sites-available/guacamole.conf
#
<VirtualHost *:80>
      ServerName guacamole.test.org

      ErrorLog ${APACHE_LOG_DIR}/guacamole_error.log
      CustomLog ${APACHE_LOG_DIR}/guacamole_access.log combined

      <Location />
          Require all granted
          ProxyPass http://localhost:8080/guacamole/ flushpackets=on
          ProxyPassReverse http://localhost:8080/guacamole/
      </Location>

     <Location /websocket-tunnel>
         Require all granted
         ProxyPass ws://localhost:8080/guacamole/websocket-tunnel
         ProxyPassReverse ws://localhost:8080/guacamole/websocket-tunnel
     </Location>

     Header always unset X-Frame-Options
</VirtualHost>
#
root@guacamole:/etc/apache2/sites-available# a2ensite guacamole.conf 
root@guacamole:/etc/apache2/sites-available# systemctl reload apache2
```

![PracticaImg](images/iaw/guaca1.png "Imagen de la practica")


