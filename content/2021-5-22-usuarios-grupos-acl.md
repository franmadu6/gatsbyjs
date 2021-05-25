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
dn: uid=fran,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: person
cn:: TWFudWVsIExvcmEgUm9tw6FuCg==
uid: fran
uidNumber: 2001
gidNumber: 2500
homeDirectory: /home/fran
loginShell: /bin/bash
userPassword:: {SSHA}R1KeFc7CI0TScCwdyQFMIEIutcEknB1F
sn:: TG9yYSBSb23DoW4K
mail: frangodh97@gmail.com
givenName: Fran

dn: uid=miriam,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: person
cn:: TWFyaWEgZGVsIENhcm1lbiBMb3JhIFJvbcOhbgo=
uid: miriam
uidNumber: 2002
gidNumber: 2502
homeDirectory: /home/miriam
loginShell: /bin/bash
userPassword:: {SSHA}OuK8ryroLXs+fpudBXcJrMTZ3ASD/H46
sn:: TG9yYSBSb23DoW4K
mail: miriamromanolopez@gmail.com
givenName: Miriam

dn: uid=juan,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: Um9zYXVyYSBIYWJhIFBlcmVhCg==
uid: juan
uidNumber: 2003
gidNumber: 2503
homeDirectory: /home/juan
loginShell: /bin/bash
userPassword: {SSHA}sgJUlNb20SdYbUclyXQNFCe0tjjdijdS
sn: SGFiYSBQZXJlYQo=
mail: juancaespinosa@gmail.com
givenName: Juan

dn: uid=manuel,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: TGF1cmEgTW9yYWxlcyBDYWJlbGxvCg==
uid: manuel
uidNumber: 2004
gidNumber: 2504
homeDirectory: /home/manuel
loginShell: /bin/bash
userPassword: {SSHA}bZ1BzoZWQGN25d5ecDzOVfaSi35h7/Dq
sn: TW9yYWxlcyBDYWJlbGxvCg==
mail: manuelsanchezvarela@gmail.com
givenName: Manuel

dn: uid=brayan,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: UGFibG8gU3VzbyBHb256YWxlego=
uid: brayan
uidNumber: 2005
gidNumber: 2505
homeDirectory: /home/brayan
loginShell: /bin/bash
userPassword: {SSHA}1Dmh5fQgowk0Cvfzje4B71kC1SmeiIqi
sn: U3VzbyBHb256YWxlego=
mail: brayanortegajuan@gmail.com
givenName: Brayan

dn: uid=axier,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: QXJ0dXJvIEJvcnJlcm8gR29uemFsZXoK
uid: axier
uidNumber: 2006
gidNumber: 2506
homeDirectory: /home/axier
loginShell: /bin/bash
userPassword: {SSHA}RoA4bctGSRG537NslZYSifHAmzf0DWTv
sn: Qm9ycmVybyBHb256YWxlego=
mail: axierortegajuan@gmail.com
givenName: Axier

dn: uid=alba,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: RGllZ28gTG9zYWRhIEZ1ZW50ZXMK
uid: alba
uidNumber: 2007
gidNumber: 2507
homeDirectory: /home/alba
loginShell: /bin/bash
userPassword: {SSHA}pclPYfaM0zvJos+h86gu+bx//Q+UULyj
sn: TG9zYWRhIEZ1ZW50ZXMK
mail: albamadueñojurado@gmail.com
givenName: Alba

dn: uid=joaquin,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: SXNhYmVsIE1vcmFsZXMgQ2FiZWxsbwo=
uid: joaquin
uidNumber: 2008
gidNumber: 2508
homeDirectory: /home/joaquin
loginShell: /bin/bash
userPassword: {SSHA}cBES958lKSd7Trpj7Yrah5yHfX4Ikl/e
sn: TW9yYWxlcyBDYWJlbGxvCg==
mail: joaquinligero@gmail.com
givenName: Joaquin

dn: uid=alberto,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: QWxiZXJ0byBDb3Jkb24gQXJldmFsbwo=
uid: alberto
uidNumber: 2009
gidNumber: 2509
homeDirectory: /home/alberto
loginShell: /bin/bash
userPassword: {SSHA}GMTZonB3W7TcL9D0BEVfO7Z6xUVKbir8
sn: Q29yZG9uIEFyZXZhbG8K
mail: albertoperez@gmail.com
givenName: Alberto

dn: uid=moises,ou=Personas,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: Um9zYWxpYSBDb3Jkb24gQXJldmFsbwo=
uid: moises
uidNumber: 2010
gidNumber: 2510
homeDirectory: /home/moises
loginShell: /bin/bash
userPassword: {SSHA}fmbcJQuDFJY6+fW3KXBs8NDHugw5ULuO
sn: Q29yZG9uIEFyZXZhbG8K
mail: moisesmonge@gmail.com
givenName: Moises
```

Ejecutamos el fichero:
```shell
ldapadd -x -D cn=admin,dc=madu,dc=gonzalonazareno,dc=org -W -f usuarios.ldif
Enter LDAP Password: 


```

2. ## Crea 3 grupos en LDAP dentro de una unidad organizativa diferente que sean objetos del tipo GruposOfNames. Estos grupos serán: comercial, almacen y admin

Crearemos el archivo **grupos.ldif**:
```shell
dn: cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: GruposOfNames
cn: comercial
member:

dn: cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: GruposOfNames
cn: almacen  
member:

dn: cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: GruposOfNames
cn: admin    
member:
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
member: uid=fran,ou=People,dc=madu,dc=gonzalonazareno,dc=org

dn: cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
changetype:modify
replace: member
member: uid=miriam,ou=People,dc=madu,dc=gonzalonazareno,dc=org

dn: cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=juan,ou=People,dc=madu,dc=gonzalonazareno,dc=org

dn: cn=almacen,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=juan,ou=People,dc=madu,dc=gonzalonazareno,dc=org

dn: cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
changetype:modify
replace: member
member: uid=joaquin,ou=People,dc=madu,dc=gonzalonazareno,dc=org

dn: cn=comercial,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=joaquin,ou=People,dc=madu,dc=gonzalonazareno,dc=org

dn: cn=admin,ou=Grupos,dc=madu,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=alba,ou=People,dc=madu,dc=gonzalonazareno,dc=org
```

Añadimos las modificaciones:
```shell
ldapmodify -x -D cn=admin,dc=madu,dc=gonzalonazareno,dc=org -W -f grupousuario.ldif
Enter LDAP Password: 
```

Comprobamos los cambios realizados:
```shell
ldapsearch -h freston -x -b ou=Group,dc=madu,dc=gonzalonazareno,dc=org
```

3. ## Modifica OpenLDAP apropiadamente para que se pueda obtener los grupos a los que pertenece cada usuario a través del atributo "memberOf".



4. ## Crea las ACLs necesarias para que los usuarios del grupo almacen puedan ver todos los atributos de todos los usuarios pero solo puedan modificar las suyas.



5. ## Crea las ACLs necesarias para que los usuarios del grupo admin puedan ver y modificar cualquier atributo de cualquier objeto.

