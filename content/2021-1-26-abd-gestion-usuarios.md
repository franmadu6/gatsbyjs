---
date: 2021-01-26
title: "[ABD] - Gestión de Usuarios"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - ABD
tags:
    - Gestión
    - Usuarios
---

## PRÁCTICA TEMA 3: USUARIOS

# ORACLE:

**1. (ORACLE, Postgres, MySQL) Crea un usuario llamado Becario y, sin usar los roles de ORACLE, dale los siguientes privilegios:**

* Conectarse a la base de datos.
* Modificar el número de errores en la introducción de la contraseña de cualquier usuario.
* Modificar índices en cualquier esquema (este privilegio podrá pasarlo a quien quiera)
* Insertar filas en scott.emp (este privilegio podrá pasarlo a quien quiera)
* Crear objetos en cualquier tablespace.
* Gestión completa de usuarios, privilegios y roles.

**2. Realiza una función de verificación de contraseñas que compruebe que la contraseña difiere en más de cinco caracteres de la anterior y que la longitud de la misma es diferente de la anterior. Asígnala al perfil CONTRASEÑASEGURA. Comprueba que funciona correctamente.**

**3. Realiza un procedimiento llamado MostrarPrivilegiosdelRol que reciba el nombre de un rol y muestre los privilegios de sistema y los privilegios sobre objetos que lo componen.**

**4. Realiza un procedimiento llamado PermisosdeAsobreB que reciba dos nombres de usuario y muestre los permisos que tiene el primero de ellos sobre objetos del segundo.**

**5. Realiza un procedimiento llamado MostrarInfoPerfil que reciba el nombre de un perfil y muestre su composición y los usuarios que lo tienen asignado.**

**6. (ORACLE, Postgres) Realiza un procedimiento que reciba un nombre de usuario y nos muestre cuántas sesiones tiene abiertas en este momento. Además, para cada una de dichas sesiones nos mostrará la hora de comienzo y el nombre de la máquina, sistema operativo y programa desde el que fue abierta.**

**7. (ORACLE) Realiza un procedimiento que muestre los usuarios que pueden conceder privilegios de sistema a otros usuarios y cuales son dichos privilegios.**
       
# MySQL:

**8. Averigua que privilegios de sistema hay en MySQL y como se asignan a un usuario.**
       
**9. Averigua cual es la forma de asignar y revocar privilegios sobre una tabla concreta en MySQL.**
       
**10. Averigua si existe el concepto de rol en MySQL y señala las diferencias con los roles de ORACLE.**
       
**11. Averigua si existe el concepto de perfil como conjunto de límites sobre el uso de recursos o sobre la contraseña en MySQL y señala las diferencias con los perfiles de ORACLE.**

**12. Realiza consultas al diccionario de datos de MySQL para averiguar todos los privilegios que tiene un usuario concreto.**

**13. Realiza consultas al diccionario de datos en MySQL para averiguar qué usuarios pueden consultar una tabla concreta.**