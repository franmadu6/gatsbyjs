---
date: 2020-11-19
title: "Tarea OVH. Aplicaciones PHP"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - IAW
tags:
    - OVH
    - PHP
---

## Instalación/migración de aplicaciones web PHP
<hr>

Realizar la migración de la aplicación drupal que tienes instalada en el entorno de desarrollo a nuestro entorno de producción, para ello ten en cuenta lo siguiente:

1. La aplicación se tendrá que migrar a un nuevo virtualhost al que se accederá con el nombre portal.iesgnXX.es.

```shell
server {
        listen 80;
        listen [::]:80;
        
	root /var/www/portal;
        
	index index.php index.html;
        
	server_name portal.iesgn11.es;
        
	location / {
                try_files $uri $uri/ =404;
        }

	location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        }
}
```

2. Vamos a nombrar el servicio de base de datos que tenemos en producción. Como es un servicio interno no la vamos a nombrar en la zona DNS, la vamos a nombrar usando resolución estática. El nombre del servicio de base de datos se debe llamar: bd.iesgnXX.es.

3. Por lo tanto los recursos que deberás crear en la base de datos serán (respeta los nombres):

    Dirección de la base de datos: bd.iesgnXX.es
    Base de datos: bd_drupal
    Usuario: user_drupal
    Password: pass_drupal

4. Realiza la migración de la aplicación.

5. Asegurate que las URL limpias de drupal siguen funcionando en nginx.

6. La aplicación debe estar disponible en la URL: portal.iesgnXX.es (Sin ningún directorio).


## Instalación / migración de la aplicación Nextcloud
<hr>

1. Instala la aplicación web Nextcloud en tu entorno de desarrollo.

2. Realiza la migración al servidor en producción, para que la aplicación sea accesible en la URL: www.iesgnXX.es/cloud

3. Instala en un ordenador el cliente de nextcloud y realiza la configuración adecuada para acceder a "tu nube".
