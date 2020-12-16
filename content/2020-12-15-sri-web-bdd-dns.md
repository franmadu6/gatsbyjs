---
date: 2020-12-15
title: "OpenStack: Servidores Web, Base de Datos y DNS"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - SRI
tags:
    - OpenStack
    - Servidor Web
    - Base de datos
    - DNS
---

https://dit.gonzalonazareno.org/redmine/projects/asir2/wiki/Servidores_Web_y_DNS

vista externa (172.22.0.0/15)
    zona resolución directa
        dulcinea 172.22.x.x
        www cname dulcinea
    zona resolucón inversa
        no tiene

vista interna (10.0.1.0/24)
    zona resolución directa
        dulcinea 10.0.1.X
        sancho 10.0.1.X
        quijote 10.0.2.X
        www cname quijote
        bd cname sancho

    zona resolución inversa
        2 zonas : una para 10.0.1.0/24 y otra para 10.0.2.0/24

vista dmz(10.0.2.0/24)
    zona resolución directa
        NS freston
        dulcinea 10.0.2.X
        sancho 10.0.1.X
        quijote 10.0.2.X
        www cname quijote
        bd cname sancho


1 configuro bind con vistas
2 regla dnat en dulcinea para redirigir trafico dns a freston
3 pruebo bind con clientes en las distintas redes









