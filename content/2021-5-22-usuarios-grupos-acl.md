---
date: 2021-5-22
title: "Usuarios, grupos y ACLs en LDAP"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - ASO
tags:
    - LDAP
    - Servidor
    - Frestón
    - ACL
    - Usuarios
    - Grupos
---


1. ## Crea 10 usuarios con los nombres que prefieras en LDAP, esos usuarios deben ser objetos de los tipos posixAccount e inetOrgPerson. Estos usuarios tendrán un atributo userPassword.

2. ## Crea 3 grupos en LDAP dentro de una unidad organizativa diferente que sean objetos del tipo groupOfNames. Estos grupos serán: comercial, almacen y admin
    Añade usuarios que pertenezcan a:
        Solo al grupo comercial
        Solo al grupo almacen
        Al grupo comercial y almacen
        Al grupo admin y comercial
        Solo al grupo admin

3. ## Modifica OpenLDAP apropiadamente para que se pueda obtener los grupos a los que pertenece cada usuario a través del atributo "memberOf".

4. ## Crea las ACLs necesarias para que los usuarios del grupo almacen puedan ver todos los atributos de todos los usuarios pero solo puedan modificar las suyas.

5. ## Crea las ACLs necesarias para que los usuarios del grupo admin puedan ver y modificar cualquier atributo de cualquier objeto.

