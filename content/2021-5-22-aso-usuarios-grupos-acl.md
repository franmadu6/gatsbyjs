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

* Atributos obligatorios del objectClass posixAccount son: cn, uid, uidNumber, gidNumber, homeDirectory
* El atributo userPassword no es obligatorio.
* El objectClass inetOrgPerson no tiene atributos obligatorios.
* En cuanto a la unidad organizativa reutilizaremos la anteriormente creada llamada **Personas**.

Crearemos el fichero **usuarios.ldif**:
```shell
dn: uid=peralta,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uid: peralta
gidNumber: 2500
uidNumber: 2000
homeDirectory: /home/paco.peralta
loginShell: /bin/bash
description: descripcion de paco peralta
sn: peralta
givenName: paco
cn: paco peralta
mail: pako@gmail.com
userPassword: {SSHA}bxtPJ5LJz0JWA0/XGhc+970so1BvmsZr

dn: uid=iniesta,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uid: iniesta
gidNumber: 2500
uidNumber: 2001
homeDirectory: /home/andres.iniesta
loginShell: /bin/bash
description: descripcion de andres iniesta
sn: iniesta
givenName: andres
cn: andres iniesta
mail: diosito@gmail.com
userPassword: {SSHA}IEvD4Fek71iVjQ/XeRiRuRPuTu2TprIi

dn: uid=ramos,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uid: ramos
gidNumber: 2500
uidNumber: 2002
homeDirectory: /home/sergio.ramos
loginShell: /bin/bash
description: descripcion de sergio ramos
sn: ramos
givenName: sergio
cn: sergio ramos
mail: pelotero@gmail.com
userPassword: {SSHA}q106tZuNnwgWY24/PNaPOAWqUIGfP8KN

dn: uid=nadal,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uid: nadal
gidNumber: 2500
uidNumber: 2003
homeDirectory: /home/rafael.nadal
loginShell: /bin/bash
description: descripcion de rafael nadal
sn: nadal
givenName: rafael
cn: rafael nadal
mail: rafatenis@gmail.com
userPassword: {SSHA}Um7G3DheRZQRWmEJXCpQtHwJtZAihDIq

dn: uid=rico,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uid: rico
gidNumber: 2500
uidNumber: 2004
homeDirectory: /home/javi.rico
loginShell: /bin/bash
description: descripcion de javi rico
sn: rico
givenName: javi
cn: javi rico
mail: javirico@gmail.com
userPassword: {SSHA}2IAjgCgQfJg1vT8k5qEASBrRKwAJG0Yu

dn: uid=simson,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uid: simson
gidNumber: 2500
uidNumber: 2005
homeDirectory: /home/homer.simson
loginShell: /bin/bash
description: descripcion de homer simson
sn: simson
givenName: homer
cn: homer simson
mail: homero@gmail.com
userPassword: {SSHA}MKmeM70l2fTa03Nb7+KRL6Tm+BV6GBRS

dn: uid=pataki,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uid: pataki
gidNumber: 2500
uidNumber: 2006
homeDirectory: /home/elsa.pataki
loginShell: /bin/bash
description: descripcion de elsa pataki
sn: pataki
givenName: elsa
cn: elsa pataki
mail: elsapa@gmail.com
userPassword: {SSHA}uUsheb7UZ/0EtMpXR02L7TPOn27LKsPg

dn: uid=merced,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uid: merced
gidNumber: 2500
uidNumber: 2007
homeDirectory: /home/jose.merced
loginShell: /bin/bash
description: descripcion de jose merced
sn: merced
givenName: jose
cn: jose merced
mail: joseme@gmail.com
userPassword: {SSHA}S02IXcYNs/wU054fCsnvcTsIFDfKGzpu

dn: uid=perez,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uid: perez
gidNumber: 2500
uidNumber: 2008
homeDirectory: /home/alberto.perez
loginShell: /bin/bash
description: descripcion de alberto perez
sn: perez
givenName: alberto
cn: alberto perez
mail: albertpe@gmail.com
userPassword: {SSHA}2s8JtaEp8v+bXfN598MlG2uEm+Yf4N4Z

dn: uid=jurado,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uid: jurado
gidNumber: 2500
uidNumber: 2009
homeDirectory: /home/fran.jurado
loginShell: /bin/bash
description: descripcion de fran jurado
sn: jurado
givenName: fran
cn: fran jurado
mail: franjur@gmail.com
userPassword: {SSHA}jjEEhPdIjcLJHC+VWA+U05lvEYJQwVoV
```

Ejecutamos el fichero:
```shell
root@freston:/home/debian# ldapadd -x -D cn=admin,dc=madu,dc=gonzalonazareno,dc=org -W -f personas.ldif 
Enter LDAP Password: 
adding new entry "uid=peralta,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org"

adding new entry "uid=iniesta,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org"

adding new entry "uid=ramos,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org"

adding new entry "uid=nadal,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org"

adding new entry "uid=rico,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org"

adding new entry "uid=simson,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org"

adding new entry "uid=pataki,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org"

adding new entry "uid=merced,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org"

adding new entry "uid=perez,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org"

adding new entry "uid=jurado,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org"
```

2. ## Crea 3 grupos en LDAP dentro de una unidad organizativa diferente que sean objetos del tipo GruposOfNames. Estos grupos serán: comercial, almacen y admin

Crearemos el archivo **grupos.ldif**:
```shell
dn: cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: comercial
member:

dn: cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: almacen  
member:

dn: cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: admin    
member:
```

```shell
root@freston:/home/debian# ldapadd -x -D cn=admin,dc=madu,dc=gonzalonazareno,dc=org -W -f grupos.ldif
Enter LDAP Password: 
adding new entry "cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

adding new entry "cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

adding new entry "cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"
```

* Añade usuarios que pertenezcan a:
    - Solo al grupo comercial
    - Solo al grupo almacen
    - Al grupo comercial y almacen
    - Al grupo admin y comercial
    - Solo al grupo admin

Crearemos **gruposusuarios.ldif**
```shell
dn: cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
changetype:modify
replace: member
member: uid=peralta,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org

dn: cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
changetype:modify
replace: member
member: uid=iniesta,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org

dn: cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=ramos,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org

dn: cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=ramos,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org

dn: cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
changetype:modify
replace: member
member: uid=rico,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org

dn: cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=rico,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org

dn: cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=pataki,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
```

Añadimos las modificaciones:
```shell
root@freston:/home/debian# ldapmodify -x -D cn=admin,dc=madu,dc=gonzalonazareno,dc=org -W -f gruposusuarios.ldif 
Enter LDAP Password: 
modifying entry "cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

modifying entry "cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

modifying entry "cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

modifying entry "cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

modifying entry "cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

modifying entry "cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

modifying entry "cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"
```

Comprobamos los cambios realizados:
```shell
root@freston:/home/debian# ldapsearch -h freston -x -b ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
# extended LDIF
#
# LDAPv3
# base <ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# Grupos, madu.gonzalonazareno.org
dn: ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
objectClass: organizationalUnit
ou: Grupos

# admin, Grupos, madu.gonzalonazareno.org
dn: cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn:: YWRtaW4gICAg
member: uid=rico,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
member: uid=pataki,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org

# almacen, Grupos, madu.gonzalonazareno.org
dn: cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn:: YWxtYWNlbiAg
member: uid=iniesta,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
member: uid=ramos,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org

# comercial, Grupos, madu.gonzalonazareno.org
dn: cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: comercial
member: uid=peralta,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
member: uid=ramos,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
member: uid=rico,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org

# search result
search: 2
result: 0 Success

# numResponses: 5
# numEntries: 4
```

3. ## Modifica OpenLDAP apropiadamente para que se pueda obtener los grupos a los que pertenece cada usuario a través del atributo "memberOf".

Para ello añadiremos el atributo "memberOf" a un nuevo fichero de configuración el cual nos permitirá cargar el módulo **memberof.la**.
```shell
root@freston:/home/debian/prueba# cat memberofdef.ldif 
dn: cn=module,cn=config
cn: module
objectClass: olcModuleList
objectclass: top
olcModuleLoad: memberof.la
olcModulePath: /usr/lib/ldap

dn: olcOverlay={0}memberof,olcDatabase={1}mdb,cn=config
objectClass: olcConfig
objectClass: olcMemberOf
objectClass: olcOverlayConfig
objectClass: top
olcOverlay: memberof
olcMemberOfDangling: ignore
olcMemberOfRefInt: TRUE
olcMemberOfGroupOC: groupOfNames
olcMemberOfMemberAD: member
olcMemberOfMemberOfAD: memberOf
```

Ahora configuraremos la **integridad refencial** que basicamente es hacer relaciones entre usuarios y grupos. Para ello crearemos los siguientes dos archivos:
```shell
root@freston:/home/debian/prueba# cat refintla.ldif 
dn: cn=module,cn=config
cn: module
objectclass: olcModuleList
objectclass: top
olcmoduleload: refint.la
olcmodulepath: /usr/lib/ldap

dn: olcOverlay={1}refint,olcDatabase={1}mdb,cn=config
objectClass: olcConfig
objectClass: olcOverlayConfig
objectClass: olcRefintConfig
objectClass: top
olcOverlay: {1}refint
olcRefintAttribute: memberof member manager owner

dn: olcOverlay=memberof,olcDatabase={1}mdb,cn=config
objectClass: olcOverlayConfig
objectClass: olcMemberOf
olcOverlay: memberof
olcMemberOfRefint: TRUE
```

Los cargamos:
```shell
root@freston:/home/debian/prueba# ldapadd -Q -Y EXTERNAL -H ldapi:/// -f memberofdef.ldif 
adding new entry "cn=module,cn=config"

adding new entry "olcOverlay={0}memberof,olcDatabase={1}mdb,cn=config"

root@freston:/home/debian/prueba# nano refintla.ldif
root@freston:/home/debian/prueba# sudo ldapadd -Y EXTERNAL -H ldapi:/// -f refintla.ldif 
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
adding new entry "cn=module,cn=config"

adding new entry "olcOverlay={1}refint,olcDatabase={1}mdb,cn=config"

adding new entry "olcOverlay=memberof,olcDatabase={1}mdb,cn=config"

root@freston:/home/debian# slapcat -n 0 | grep olcModuleLoad
olcModuleLoad: {0}back_mdb
olcModuleLoad: {0}refint.la
olcModuleLoad: {0}memberof.la
```

Deberemos borrar los objetos creados anteriormente en el grupo para que se apliquen los cambios:
```shell
root@freston:/home/debian# sudo ldapdelete -x -D "cn=admin,dc=madu,dc=gonzalonazareno,dc=org" 'cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org' -W
Enter LDAP Password: 
root@freston:/home/debian# sudo ldapdelete -x -D "cn=admin,dc=madu,dc=gonzalonazareno,dc=org" 'cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org' -W
Enter LDAP Password: 
root@freston:/home/debian# sudo ldapdelete -x -D "cn=admin,dc=madu,dc=gonzalonazareno,dc=org" 'cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org' -W
Enter LDAP Password: 
```

y los volvemos a añadir:
```shell
root@freston:/home/debian/ldap# ldapadd -x -D cn=admin,dc=madu,dc=gonzalonazareno,dc=org -W -f grupos.ldif
Enter LDAP Password: 
adding new entry "cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

adding new entry "cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

adding new entry "cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

root@freston:/home/debian/ldap# ldapmodify -x -D cn=admin,dc=madu,dc=gonzalonazareno,dc=org -W -f gruposusuarios.ldif 
Enter LDAP Password: 
modifying entry "cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

modifying entry "cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

modifying entry "cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

modifying entry "cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

modifying entry "cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

modifying entry "cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"

modifying entry "cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org"
```

Y finalmente comprobaremos:
```shell
root@freston:/home/debian/prueba# sudo ldapsearch -LL -Y EXTERNAL -H ldapi:/// "(uid=ramos)" -b dc=madu,dc=gonzalonazareno,dc=org memberOf
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
version: 1

dn: uid=ramos,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
memberOf: cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
memberOf: cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
```

4. ## Crea las ACLs necesarias para que los usuarios del grupo almacen puedan ver todos los atributos de todos los usuarios pero solo puedan modificar las suyas.

Crearemos un nuevo fichero para configurar la **ACL**.
```shell
root@freston:/home/debian/ldap# nano acl.ldif

dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcAccess
olcAccess: {3}to filter=(&(objectclass=inetOrgPerson)(memberof=cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org)) by group.exact="cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org" write 
```
 
y lo añadiremos:
```shell
root@freston:/home/debian/ldap# sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f acl.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "olcDatabase={1}mdb,cn=config"
```


5. ## Crea las ACLs necesarias para que los usuarios del grupo admin puedan ver y modificar cualquier atributo de cualquier objeto.

Crearemos otro fichero para la nueva configuración de **ACL** que contrenda la siguiente:
```shell
root@freston:/home/debian/ldap# nano acl2.ldif

dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcAccess
olcAccess: {4}to * by group.exact="cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org" write
```

y lo añadiremos:
```shell
root@freston:/home/debian/ldap# sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f acl2.ldif 
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "olcDatabase={1}mdb,cn=config"
```

