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

```shell

```

**2. Realiza una función de verificación de contraseñas que compruebe que la contraseña difiere en más de cinco caracteres de la anterior y que la longitud de la misma es diferente de la anterior. Asígnala al perfil CONTRASEÑASEGURA. Comprueba que funciona correctamente.**
```shell

```

**3. Realiza un procedimiento llamado MostrarPrivilegiosdelRol que reciba el nombre de un rol y muestre los privilegios de sistema y los privilegios sobre objetos que lo componen.**
```shell

```

**4. Realiza un procedimiento llamado PermisosdeAsobreB que reciba dos nombres de usuario y muestre los permisos que tiene el primero de ellos sobre objetos del segundo.**
```shell

```

**5. Realiza un procedimiento llamado MostrarInfoPerfil que reciba el nombre de un perfil y muestre su composición y los usuarios que lo tienen asignado.**
```shell

```

**6. (ORACLE, Postgres) Realiza un procedimiento que reciba un nombre de usuario y nos muestre cuántas sesiones tiene abiertas en este momento. Además, para cada una de dichas sesiones nos mostrará la hora de comienzo y el nombre de la máquina, sistema operativo y programa desde el que fue abierta.**
```shell

```

**7. (ORACLE) Realiza un procedimiento que muestre los usuarios que pueden conceder privilegios de sistema a otros usuarios y cuales son dichos privilegios.**
```shell

```

# MySQL:

Antes de comenzar crearemos una base de datos y un usuario de prueba:
```shell
MariaDB [(none)]> create database testdeusuarios;
Query OK, 1 row affected (0.000 sec)

MariaDB [(none)]> use testdeusuarios;
Database changed
MariaDB [testdeusuarios]> CREATE TABLE mitabla(
    ->          id MEDIUMINT NOT NULL AUTO_INCREMENT,
    ->          nombre CHAR(30) NOT NULL,
    ->          edad INTEGER(30),
    ->          salario INTEGER(30),
    ->          PRIMARY KEY (id) );
Query OK, 0 rows affected (0.031 sec)
MariaDB [testdeusuarios]> INSERT INTO mitabla (nombre, edad, salario) VALUES
    ->         ("Pedro", 24, 21000),
    ->         ("Maria", 26, 24000),
    ->         ("Juan", 28, 25000),
    ->         ("Luis", 35, 28000),
    ->         ("Monica", 42, 30000),
    ->         ("Rosa", 43, 25000),
    ->         ("Susana", 45, 39000);
Query OK, 7 rows affected (0.017 sec)
Records: 7  Duplicates: 0  Warnings: 0
MariaDB [testdeusuarios]> CREATE USER 'permisosuser'@'localhost' IDENTIFIED BY 'fran';
Query OK, 0 rows affected (0.004 sec)
```

**8. Averigua que privilegios de sistema hay en MySQL y como se asignan a un usuario.**

<center><img alt="Privilegios" src="https://wiki.cifprodolfoucha.es/images/b/b3/Mysql_seguridad_20.jpg"/></center>


**9. Averigua cual es la forma de asignar y revocar privilegios sobre una tabla concreta en MySQL.**
```shell
#asignar permisos en una tabla concreta
MariaDB [testdeusuarios]> grant select on testdeusuarios.mitabla to 'permisosuser'@'localhost';
Query OK, 0 rows affected (0.001 sec)

MariaDB [testdeusuarios]> SHOW GRANTS FOR 'permisosuser'@'localhost';
+---------------------------------------------------------------------------------------------------------------------+
| Grants for permisosuser@localhost                                                                                   |
+---------------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `permisosuser`@`localhost` IDENTIFIED BY PASSWORD '*C21820D07C10B6E384D073EBC018312F95E2848E' |
| GRANT SELECT ON `testdeusuarios`.`mitabla` TO `permisosuser`@`localhost`                                            |
+---------------------------------------------------------------------------------------------------------------------+
2 rows in set (0.000 sec)
#revocar permisos en una tabla concreta
MariaDB [testdeusuarios]> revoke all privileges on testdeusuarios.mitabla from 'permisosuser'@'localhost';
Query OK, 0 rows affected (0.001 sec)

MariaDB [testdeusuarios]> SHOW GRANTS FOR 'permisosuser'@'localhost';
+---------------------------------------------------------------------------------------------------------------------+
| Grants for permisosuser@localhost                                                                                   |
+---------------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `permisosuser`@`localhost` IDENTIFIED BY PASSWORD '*C21820D07C10B6E384D073EBC018312F95E2848E' |
+---------------------------------------------------------------------------------------------------------------------+
1 row in set (0.000 sec)
```

**10. Averigua si existe el concepto de rol en MySQL y señala las diferencias con los roles de ORACLE.**
```shell

```

**11. Averigua si existe el concepto de perfil como conjunto de límites sobre el uso de recursos o sobre la contraseña en MySQL y señala las diferencias con los perfiles de ORACLE.**
```shell

```

**12. Realiza consultas al diccionario de datos de MySQL para averiguar todos los privilegios que tiene un usuario concreto.**
```shell

```

**13. Realiza consultas al diccionario de datos en MySQL para averiguar qué usuarios pueden consultar una tabla concreta.**
```shell

```