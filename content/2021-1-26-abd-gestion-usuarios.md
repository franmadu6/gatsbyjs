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
```shell
Create user Becario identified by Becario;
```

* Conectarse a la base de datos.
```shell
grant create session to Becario;
```

* Modificar el número de errores en la introducción de la contraseña de cualquier usuario.
```shell
grant create profile to Becario;
#
Create profile Limitepasswd LIMIT
FAILED_LOGIN_ATTEMPTS 5
;
#Ahora le damos al usuario becarios la posibilidad de dar dicho perfil
grant alter user to Becario;
#Y ahora este usuario podría dar el perfil a diferentes usuarios
Alter user {USUARIO} profile Limitepasswd;
```

* Modificar índices en cualquier esquema (este privilegio podrá pasarlo a quien quiera)
```shell
alter index fran.PK_CODIGO_COCHES RENAME TO PK_CODIGO_COCHES1;
```

* Insertar filas en scott.emp (este privilegio podrá pasarlo a quien quiera)
```shell
grant insert on SCOTT.EMP to Becario with grant option;
```

* Crear objetos en cualquier tablespace.
```shell
grant unlimited tablespace to Becario;
```

* Gestión completa de usuarios, privilegios y roles.
```shell
#Usuarios
grant create user to Becario;
grant alter user to Becario;
grant drop user to Becario;
#Privilegios
grant grant any privilege to Becario;
#Roles
grant create role to Becario;
grant drop any role to Becario;
grant alter any role to Becario;
grant grant any role to Becario;
```


**2. Realiza una función de verificación de contraseñas que compruebe que la contraseña difiere en más de cinco caracteres de la anterior y que la longitud de la misma es diferente de la anterior. Asígnala al perfil CONTRASEÑASEGURA. Comprueba que funciona correctamente.**
```shell
create or replace function funciondeVerificacion (
    username VARCHAR2, 
    pass VARCHAR2, 
    old_password VARCHAR2)
return varchar2   IS 
begin
	if length(pass) < 6 then return 'FALSE';
	elsif (pass = old_password) then return 'FALSE';
	else return 'TRUE';
    end if;
end;
```

**3. Realiza un procedimiento llamado MostrarPrivilegiosdelRol que reciba el nombre de un rol y muestre los privilegios de sistema y los privilegios sobre objetos que lo componen.**
```shell
create or replace procedure MostrarPrivilegiosdelRol(p_rol varchar2)
is
begin
	select grantee, privilege from dba_sys_privs
	where privilege=p_rol; 
	if p_rol=0 then
		raise_application_error(-20001,'Ese rol no existe');
	end if;
end;
/
```

**4. Realiza un procedimiento llamado PermisosdeAsobreB que reciba dos nombres de usuario y muestre los permisos que tiene el primero de ellos sobre objetos del segundo.**
```shell

```

**5. Realiza un procedimiento llamado MostrarInfoPerfil que reciba el nombre de un perfil y muestre su composición y los usuarios que lo tienen asignado.**

(Para que los perfiles funcionen, el parámetro de la base de datos resource_limit, deberá tener el valor a true.)

```shell
Create or replace procedure MostrarInfoPerfil(p.name varchar2)
is
begin
	select profile, username, default_tablespace, temporary_tablespace
    from   dba_users
    where  profile = p.name; 
	if p.name=0 then
		raise_application_error(-20001,'Ese perfil no existe');
	end if;
end;
/
```

**6. (ORACLE, Postgres) Realiza un procedimiento que reciba un nombre de usuario y nos muestre cuántas sesiones tiene abiertas en este momento. Además, para cada una de dichas sesiones nos mostrará la hora de comienzo y el nombre de la máquina, sistema operativo y programa desde el que fue abierta.**
```shell
Create or replace procedure ver.excepciones(p_user varchar2)
is
	si.existe number(1):=0;
begin
	Select count(*) into si.existe
	from dba_users
	where USERNAME=p_user;
	if si.existe=0 then
		raise_application_error(-20001,'El usuario que buscas no existe');
	end if;
end;
/

#El nombre del sistema operativo no está disponible para buscar en Oracle, una solución que se puede hacer es buscar el usuario del sistema que está usando, pero no un sistema operativo.

Create or replace procedure ver.sesiones(p_user varchar2)
is
	cursor c.sesiones is
	select MACHINE as maquina,to_char(LOGON_TIME,'YYYY/MM/DD HH24:MI') as comienzo,program as programa
	from v$session 
	where USERNAME=p_user;
	contador number(2):=1;
begin
	for v.sesiones in c.sesiones loop
		dbms_output.put_line('Sesion '||contador||'->');
		dbms_output.put_line('Hora de comienzo: '||v.sesiones.comienzo);
		dbms_output.put_line('Nombre Máquina: '||v.sesiones.maquina);
		dbms_output.put_line('Nombre Programa: '||v.sesiones.programa);
		contador:=contador+1;
	end loop;
end;
/

Create or replace procedure ver.conexiones(p_user varchar2)
is
begin
	dbms_output.put_line('Usuario: '||p_user);
	ver.excepciones(p_user);
	ver.sesiones.abiertas(p_user);
	ver.sesiones(p_user);
end;
/
```

**7. (ORACLE) Realiza un procedimiento que muestre los usuarios que pueden conceder privilegios de sistema a otros usuarios y cuales son dichos privilegios.**
```shell
Create or replace procedure ver_usuario_simple(p_rol varchar2,p_privilegio varchar2)
is
	cursor c_usuarios is
	Select GRANTEE
	from dba_role_privs
	where GRANTED_ROLE=p_rol;
begin
	for v_usuarios in c_usuarios loop
		dbms_output.put_line('Usuario: '||v_usuarios.GRANTEE);
		dbms_output.put_line('Privilegio: '||p_privilegio);
		dbms_output.put_line(chr(13));
	end loop;
end;
/

Create or replace procedure ver_usuario_compuesto(p_rol varchar2,p_privilegio varchar2)
is
	cursor c_compuesto is
	select GRANTEE
   	from dba_role_privs
	start with GRANTED_ROLE = p_rol
        connect by GRANTED_ROLE = prior GRANTEE;
	v_analizarprivilegio number(1):=0;
begin
	Select count(*) into v_analizarprivilegio
	from role_sys_privs
	where ROLE=p_rol
	and PRIVILEGE=p_privilegio;
	if v_analizarprivilegio != 0 then
		for v_compuesto in c_compuesto loop
			ver_usuario_simple(v_compuesto.GRANTEE,p_privilegio);
		end loop;
	else
		ver_usuario_simple(p_rol,p_privilegio);
	end if;
end;
/

Create or replace procedure privilegios_superusuario_rol
is
	cursor c_privs is
	Select GRANTEE,PRIVILEGE
	from dba_sys_privs
	where ADMIN_OPTION='YES'
	and GRANTEE in (Select ROLE
			FROM DBA_ROLES);
	v_compuesto number(1):=0;
	v_rol varchar2(1000):='SIMPLE';
begin
	for v_privs in c_privs loop
		SELECT count(*) into v_compuesto
		FROM DBA_ROLE_PRIVS
		where GRANTED_ROLE=v_privs.GRANTEE;
		if v_compuesto=0 then
			ver_usuario_simple(v_privs.GRANTEE,v_privs.PRIVILEGE);
		else
			ver_usuario_compuesto(v_privs.GRANTEE,v_privs.PRIVILEGE);
		end if;
	end loop;
end;
/


Create or replace procedure privilegios_superusuario_directo
is
	cursor c_privsd is
	Select GRANTEE,PRIVILEGE
	from dba_sys_privs
	where ADMIN_OPTION='YES'
	and GRANTEE in (Select USERNAME
			FROM DBA_USERS);
begin
	for v_privsd in c_privsd loop
		dbms_output.put_line('Usuario: '||v_privsd.GRANTEE);
		dbms_output.put_line('Privilegio: '||v_privsd.PRIVILEGE);
		dbms_output.put_line(chr(13));
	end loop;
end;
/

Create or replace procedure privilegios_superusuario
is
	
begin
	dbms_output.put_line('Usuarios que pueden dar privilegios');
	privilegios_superusuariodirecto;
	privilegios_superusuariorol;
end;
/
```

# MySQL:

Antes de comenzar crearemos una base de datos y un usuario de prueba para la realización de ejercicios:
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
Como asignar privilegios:

```shell
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP
    -> ON mitabla.*
    -> TO 'nombre_usuario'@'localhost';
```

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

Si, en MySQL existen los roles, e identifican un conjunto de permisos, a partir de la versión 8 de MySQL ya están disponibles.

Los roles son muy similares pero puesto a que MySQL los ha implementado hacer muy poco están algo menos desarrollados que en Oracle, por ejemplo, en Oracle existen roles que se utilizan para el uso de aplicaciones, también existen roles locales, externos o globales, y además se puede aumentar la seguridad del uso de roles añadiendoles contraseñas que permiten concretar aún más las funciones del rol que queramos crear.


**11. Averigua si existe el concepto de perfil como conjunto de límites sobre el uso de recursos o sobre la contraseña en MySQL y señala las diferencias con los perfiles de ORACLE.**

**MySQL:**

Una forma de limitar los recursos de los servidores MySQL es asignar a la variable de sistema max_user_connections un valor distinto de cero. Sin embargo,este método es estrictamente global, y no está permitido para la administración de cuentas individuales. Además, limita sólo el número de conexiones simultáneas hechas usando una sóla cuenta, y no lo que un cliente puede hacer una vez conectado. Ambos tipos de control son interesantes para muchos administradores de MySQL, particularmente aquéllos que trabajan en ISPs.

MySQL puede limitar:

- Número de consultas que un usuario pueda hacer cada hora.
- Número de updates que un usuario puede hacer cada hora.
- Número de veces que un usuario puede acceder al servidor a la hora.
- Número de conexiones simultaneas permitidas para cada usuario (como max_user_connections pero a nivel individual en lugar de global).


**Oracle:**

Un perfil de usuario es una forma de limitar los recursos que puede utilizar un usuario, cada usuario puede tener un único perfil, antes de asignar un perfil a un usuario es necesario que este perfil exista en la base de datos, un perfil se asigna en la creación de un usuario CREATE USER o modificándolo ALTER USER. 

- Los recursos que limitamos son recursos del kernel: uso de la CPU, duración de sesion,...
- Y tambien limites de uso de las claves de acceso (passwords): duración, intentos de acceso, reuso, ... 

En este caso nos volvemos a encontrar con el mismo problema aunque ambos tengan un sistema para poder controlar el uso de recursos de los usuarios, MySQL se queda muy atrás en opciones de configuración.

En Orcle la configuración es mucho mas detallada y te permite controlar prácticamente cualquier recurso utilizado por el usuario.

**12. Realiza consultas al diccionario de datos de MySQL para averiguar todos los privilegios que tiene un usuario concreto.**

Le añadiremos varios privilegios a un usuario y procederemos a ver todos los privilegios que utiliza:
```shell
MariaDB [testdeusuarios]> SHOW GRANTS FOR 'permisosuser'@'localhost';
+---------------------------------------------------------------------------------------------------------------------+
| Grants for permisosuser@localhost                                                                                   |
+---------------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `permisosuser`@`localhost` IDENTIFIED BY PASSWORD '*C21820D07C10B6E384D073EBC018312F95E2848E' |
| GRANT SELECT, INSERT, DELETE ON `testdeusuarios`.`mitabla` TO `permisosuser`@`localhost`                            |
+---------------------------------------------------------------------------------------------------------------------+
2 rows in set (0.000 sec)
```

**13. Realiza consultas al diccionario de datos en MySQL para averiguar qué usuarios pueden consultar una tabla concreta.**
```shell
MariaDB [testdeusuarios]> SELECT user, table_name FROM mysql.tables_priv;
+--------------+------------+
| user         | table_name |
+--------------+------------+
| Becario      | mitabla    |
| permisosuser | mitabla    |
+--------------+------------+
2 rows in set (0.001 sec)
```