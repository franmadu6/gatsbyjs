---
date: 2021-02-01
title: "Métricas, logs o monitorización"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - ASO
tags:
    - Métricas
    - Logs
    - Monitorización
    - Graphite
    - Grafana
    - Centreon
---

# Graphite + Grafana + Centreon

Descripción

Utiliza una de las instancias de OpenStack y realiza una de las partes que elijas entre las siguientes sobre el servidor de OVH, dulcinea, sancho, quijote y frestón:

    Métricas: recolección, gestión centralizada, filtrado o selección de los parámetros relevantes y representación gráfica que permita controlar la evolución temporal de parámetros esenciales de todos los servidores.
    Monitorización: Configuración de un sistema de monitorización que controle servidores y servicios en tiempo real y envíe alertas por uso excesivo de recursos (memoria, disco raíz, etc.) y disponibilidad de los servicios. Alertas por correo, telegram, etc.
    Gestión de logs: Implementa un sistema que centralice los logs de todos los servidores y que filtre los registros con prioridad error, critical, alert o emergency. Representa gráficamente los datos relevantes extraídos de los logs o configura el envío por correo al administrador de los logs relevantes (una opción o ambas).

Detalla en la documentación claramente las características de la implementación elegida, así como la forma de poder verificarla (envía si es necesario usuario y contraseña por correo a los profesores, para el panel web si lo hubiera, p.ej.).

Antes de comenzar la tarea debes notificarla en la wiki y debes elegir un conjunto de herramientas diferentes a las elegidas por tus compañeros.

## Graphite

Requerimientos
```shell
sudo yum -y update
sudo yum -y install httpd gcc gcc-c++ git pycairo mod_wsgi epel-release
sudo yum -y install python-pip python-devel blas-devel lapack-devel libffi-devel
```

Descarga e instalación
```shell
cd /usr/local/src
sudo git clone https://github.com/graphite-project/graphite-web.git
sudo git clone https://github.com/graphite-project/carbon.git
 
sudo pip install -r /usr/local/src/graphite-web/requirements.txt
 
cd /usr/local/src/carbon/
sudo python setup.py install
 
cd /usr/local/src/graphite-web/
sudo python setup.py install
 
sudo cp /opt/graphite/conf/carbon.conf.example /opt/graphite/conf/carbon.conf
sudo cp /opt/graphite/conf/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf
sudo cp /opt/graphite/conf/storage-aggregation.conf.example /opt/graphite/conf/storage-aggregation.conf
sudo cp /opt/graphite/conf/relay-rules.conf.example /opt/graphite/cyum install collectd collectd-snmponf/relay-rules.conf
sudo cp /opt/graphite/webapp/graphite/local_settings.py.example /opt/graphite/webapp/graphite/local_settings.py
sudo cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
sudo cp /opt/graphite/examples/example-graphite-vhost.conf /etc/httpd/conf.d/graphite.conf
 
sudo cp /usr/local/src/carbon/distro/redhat/init.d/carbon-* /etc/init.d/
sudo chmod +x /etc/init.d/carbon-*
```

pip3 install 'django<1.6'
pip3 install 'Twisted<12'
pip3 install django-tagging
pip3 install whisper
pip3 install graphite-web
pip3 install carbon

yum install collectd collectd-snmp

cp /opt/graphite/examples/example-graphite-vhost.conf /etc/httpd/conf.d/graphite.conf
cp /opt/graphite/conf/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf
cp /opt/graphite/conf/storage-aggregation.conf.example /opt/graphite/conf/storage-aggregation.conf
cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
cp /opt/graphite/conf/graphTemplates.conf.example /opt/graphite/conf/graphTemplates.conf
cp /opt/graphite/conf/carbon.conf.example /opt/graphite/conf/carbon.conf

chown -R apache:apache /opt/graphite/storage/

vi /opt/graphite/conf/storage-schemas.conf

[default]
pattern = .*
retentions = 10s:4h, 1m:3d, 5m:8d, 15m:32d, 1h:1y

[centos@quijote graphite]$ systemctl status carbon-cache.service
● carbon-cache.service - SYSV: carbon-cache
   Loaded: loaded (/etc/rc.d/init.d/carbon-cache; generated)
   Active: inactive (dead)
     Docs: man:systemd-sysv-generator(8)
[centos@quijote graphite]$ systemctl start carbon-cache.service
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ====
Authentication is required to start 'carbon-cache.service'.
Authenticating as: Cloud User (centos)
Password: 
==== AUTHENTICATION COMPLETE ====
[centos@quijote graphite]$ systemctl status carbon-cache.service
● carbon-cache.service - SYSV: carbon-cache
   Loaded: loaded (/etc/rc.d/init.d/carbon-cache; generated)
   Active: active (running) since Mon 2021-02-01 11:30:19 UTC; 8s ago
     Docs: man:systemd-sysv-generator(8)
  Process: 1144 ExecStart=/etc/rc.d/init.d/carbon-cache start (code=exited, status=0/SUCCESS)
    Tasks: 3 (limit: 2591)
   Memory: 31.4M
   CGroup: /system.slice/carbon-cache.service
           └─1161 /usr/bin/python3.6 bin/carbon-cache.py --instance=a start

Feb 01 11:30:17 quijote.madu.gonzalonazareno.org systemd[1]: Starting SYSV: carbon-cache...
Feb 01 11:30:17 quijote.madu.gonzalonazareno.org carbon-cache[1144]: Starting carbon-cache:a...
Feb 01 11:30:19 quijote.madu.gonzalonazareno.org carbon-cache[1144]: [  OK  ]
Feb 01 11:30:19 quijote.madu.gonzalonazareno.org systemd[1]: Started SYSV: carbon-cache.


Editamos el fichero de bienvenida y lo comentamos todo con almohadillas (#).
vim /etc/httpd/conf.d/welcome.conf




Modificamos el fichero ‘/etc/httpd/conf.d/graphite-web.conf’ para permitir acceso desde cualquier IP:

# Graphite Web Basic mod wsgi vhost 
<VirtualHost *:80>
        ##ServerName graphite-web 
        DocumentRoot "/usr/share/graphite/webapp"
        ErrorLog /var/log/httpd/graphite-web-error.log 
        CustomLog /var/log/httpd/graphite-web-access.log common

        # Header set Access-Control-Allow-Origin "*" 
        # Header set Access-Control-Allow-Methods "GET, OPTIONS" 
        # Header set Access-Control-Allow-Headers "origin, authorization, accept" 
        # Header set Access-Control-Allow-Credentials true 

        VSGIScriptAlias / /usr/share/graphite/graphite-web.wsgi
        VSGIImportScript /usr/share/graphite/graphite-web.wsgi process-group="i(GLOBAL) application-grou$
 
        <Location "/content/"> 
                SetHandler None 
        </Location>

        Alias /media/ "/usr/lib/python2.7/site-packages/django/contrib/admin/media,"

        <Location "/media/"> 
                SetHandler None 
        </Location>

        <Directory "/usr/share/graphite/"> 
                <IfModule mod_authz_core.c> 
                        # Apache 2.4 
                        #Require local Require all granted 
                </IfModule> 
                <IfModule !mod_authz_core.c> 
                        # Apache 2.2 
                        Order Deny,Allow 
                        #Deny from all 
                        #Allow from 127.0.0.1 
                        #Allow from ::1 
                        Allow from all 
                </IfModule> 
        </Directory>
</VirtualHost> 

----------------------------------------------------------------------------


