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

**En Oracle**
```shell
#creación de usuario.
Create user Becario identified by Becario;
#Conectarse a la base de datos.
grant create session to Becario;
#Modificar el número de errores en la introducción de la contraseña de cualquier usuario.
grant create profile to Becario;
Create profile Limitepasswd LIMIT
FAILED_LOGIN_ATTEMPTS 5;
#Ahora le damos al usuario becarios la posibilidad de dar dicho perfil
grant alter user to Becario;
#Y ahora este usuario podría dar el perfil a diferentes usuarios
Alter user {USUARIO} profile Limitepasswd;
# Modificar índices en cualquier esquema (este privilegio podrá pasarlo a quien quiera)
alter index fran.PK_CODIGO_COCHES RENAME TO PK_CODIGO_COCHES1;
# Insertar filas en scott.emp (este privilegio podrá pasarlo a quien quiera)
grant insert on SCOTT.EMP to Becario with grant option;
# Crear objetos en cualquier tablespace.
grant unlimited tablespace to Becario;
# Gestión completa de usuarios, privilegios y roles.
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

**En Postgres**
```shell
#creación de usuario.
CREATE USER Becario WITH PASSWORD 'Becario';
#Conectarse a la base de datos.
GRANT CREATE SESSION TO Becario WITH ADMIN OPTION;
#Modificar el número de errores en la introducción de la contraseña de cualquier usuario.
grant create profile to Becario;
Create profile Limitepasswd LIMIT
FAILED_LOGIN_ATTEMPTS 5;
#Ahora le damos al usuario becarios la posibilidad de dar dicho perfil
grant alter user to Becario;
#Y ahora este usuario podría dar el perfil a diferentes usuarios
Alter user {USUARIO} profile Limitepasswd;
# Modificar índices en cualquier esquema (este privilegio podrá pasarlo a quien quiera)
alter index fran.PK_CODIGO_COCHES RENAME TO PK_CODIGO_COCHES1;
# Insertar filas en scott.emp (este privilegio podrá pasarlo a quien quiera)
grant insert on SCOTT.EMP to Becario with grant option;
# Crear objetos en cualquier tablespace.
grant unlimited tablespace to Becario;
# Gestión completa de usuarios, privilegios y roles.
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

**En MariaDB**
```shell
#creación de usuario.
Create user Becario identified by Becario;
#Conectarse a la base de datos.
GRANT USAGE ON *.* TO 'Becario'@localhost IDENTIFIED BY 'Becario';
#Modificar el número de errores en la introducción de la contraseña de cualquier usuario.
log_warnings = 2
#Ahora le damos al usuario becarios la posibilidad de dar dicho perfil
grant alter user to Becario witch grant option;
#Y ahora este usuario podría dar el perfil a diferentes usuarios
Alter user {USUARIO} profile Limitepasswd;
# Modificar índices en cualquier esquema (este privilegio podrá pasarlo a quien quiera)
alter index fran.PK_CODIGO_COCHES RENAME TO PK_CODIGO_COCHES1;
# Insertar filas en scott.emp (este privilegio podrá pasarlo a quien quiera)
GRANT insert ON scott.emp.* TO 'Becario'@localhost IDENTIFIED BY "Becario" WITH GRANT OPTION;
# Crear objetos en cualquier tablespace.
grant unlimited tablespace to Becario;
# Gestión completa de usuarios, privilegios y roles.
GRANT ALL ON bdd.* TO 'Becario'@'localhost';
```

**2. Realiza una función de verificación de contraseñas que compruebe que la contraseña difiere en más de cinco caracteres de la anterior y que la longitud de la misma es diferente de la anterior. Asígnala al perfil CONTRASEÑASEGURA. Comprueba que funciona correctamente.**
```shell
create or replace function verifpasswd (p_usuario varchar2,
                                            p_pswnueva varchar2,
                                            p_pswvieja varchar2)
return boolean
is
    v_sumaRepe number:=0;
    v_letraigual number:=0;
    v_numNum number:=0;
    v_numLetra number:=0;
    v_validar number:=0;
begin
    if length(p_pswnueva)=length(p_pswvieja) then
        raise_application_error(-20003, 'La password nueva debe ser de la misma longitud que la anterior.');
    end if;
    for i in 1..length(p_pswnueva) loop
        ContarNumerosYLetras(substr(p_pswnueva, i,1), v_numNum, v_numLetra);
        CompararCaracteres(substr(p_pswnueva, i,1), p_pswvieja, v_letraigual);
        if v_letraigual=0 then
            v_sumaRepe:=v_sumaRepe+1;
        end if;
        v_letraigual:=0; 
    end loop;
    v_validar:=errores(v_sumaRepe, v_numNum, v_numLetra);
    return TRUE;
end verifpasswd;
/

create or replace function errores(p_sumaRepe number, 
                                         p_numNum number, p_numLetra number)
return number
is
begin
    case
        when p_sumaRepe<6 then
            raise_application_error(-20002, 'La password nueva debe ser diferente en 5 carácteres respecto a la anterior');
        else
            return 1;
    end case;          
end errores;
/


create or replace procedure CompararCaracteres(p_caracter varchar2,
                                               p_psw varchar2,
                                               p_letraigual in out number)
is
begin
    for i in 1..length(p_psw) loop
        if substr(p_psw,i,1)=p_caracter then
            p_letraigual:=1;
        end if;
    end loop;
end CompararCaracteres;
/


create or replace procedure ContarNumerosYLetras (p_caracter varchar2,
                                                  p_numero  in out number,
                                                  p_letra   in out number)
is
begin
    if p_caracter=REGEXP_REPLACE(p_caracter,'[0-9]') then
        p_numero:=p_numero+1;
    else
        p_letra:=p_letra+1;
    end if;
end ContarNumerosYLetras;
/
```

Creación de perfil.
```shell
create profile CONTRASENASEGURA limit 
    PASSWORD_VERIFY_FUNCTION verifpasswd;

drop profile CONTRASENASEGURA;
```

Asignación de usuario.
```shell
alter user pruebapasswd profile CONTRASENASEGURA;
```

**3. Realiza un procedimiento llamado MostrarPrivilegiosdelRol que reciba el nombre de un rol y muestre los privilegios de sistema y los privilegios sobre objetos que lo componen.**
```shell
create or replace procedure MostrarPrivileciosdelRol (p_rol varchar2)
is
    v_validacion number:=0;
begin
    v_validacion:=ComprobarSiRolExiste(p_rol);
    if v_validacion=0 then
        BuscarPrivilegiosDelSistema(p_rol);
        dbms_output.put_line(' ');
        dbms_output.put_line('--------------------------------------------------------------------------------');
        dbms_output.put_line(' ');
        BuscarPrivilegiosSobreObjetos(p_rol);
    end if;
end MostrarPrivileciosdelRol;
/

create or replace procedure BuscarPrivilegiosDelSistema(p_rol varchar2)
is
    cursor c_sys
    is
    select distinct privilege
    from role_sys_privs
    where role in (select distinct role 
                   from role_role_privs 
                   start with role=p_rol
                   connect by role = prior granted_role)
    or role = p_rol;
    v_sys c_sys%ROWTYPE;
begin
    dbms_output.put_line('PRIVILEGIOS DEL SISTEMA');
    dbms_output.put_line('--------------------------------------------------------------------------------');
    for v_sys in c_sys loop
        dbms_output.put_line(v_sys.privilege);
    end loop;
end BuscarPrivilegiosDelSistema;
/


create or replace procedure BuscarPrivilegiosSobreObjetos(p_rol varchar2)
is
    cursor c_tab
    is
    select distinct privilege, table_name, owner
    from role_tab_privs
    where role in (select distinct role 
                   from role_role_privs 
                   start with role=p_rol
                   connect by role = prior granted_role)
    or role = p_rol;
    v_tab c_tab%ROWTYPE;
begin
    dbms_output.put_line('PRIVILEGIOS SOBRE OBJETOS');
    dbms_output.put_line('--------------------------------------------------------------------------------');
    for v_tab in c_tab loop
        dbms_output.put_line(v_tab.privilege||' sobre la tabla '||v_tab.table_name||' del usuario '||v_tab.owner);
    end loop;
end BuscarPrivilegiosSobreObjetos;
/


create or replace function ComprobarSiRolExiste(p_rol varchar2)
return number
is
    v_resultado varchar2(30);
begin
    select role into v_resultado
    from dba_roles
    where role=p_rol;
    return 0;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('No existe el rol '||p_rol);
        return -1;
end ComprobarSiRolExiste;
/
```

**4. Realiza un procedimiento llamado PermisosdeAsobreB que reciba dos nombres de usuario y muestre los permisos que tiene el primero de ellos sobre objetos del segundo.**
```shell

```

**5. Realiza un procedimiento llamado MostrarInfoPerfil que reciba el nombre de un perfil y muestre su composición y los usuarios que lo tienen asignado.**

(Para que los perfiles funcionen, el parámetro de la base de datos resource_limit, deberá tener el valor a true.)

```shell
create procedure Infoperfil (p_perfil dba_profiles.profile%type)
is
	cursor c_informacion
	is
	select resource_name, limit
	from dba_profiles
	where profile = p_perfil;
begin
	dbms_output.put_line('Composición de: '|| p_perfil);	
	for i in c_informacion loop
		dbms_output.put_line('Recurso: '|| i.resource_name || ' Límites: '|| i.limit);
	end loop;
end Infoperfil;
/


create procedure MostrarInfoPerfil (p_perfil dba_profiles.profile%type)
is
	cursor c_perfiles
	is
	select username
	from dba_users
	where profile = p_perfil;
begin 
	Infoperfil(p_perfil);
	for i in c_perfiles loop
		dbms_output.put_line('Usuarios con ese perfil: '|| i.username);
	end loop;
end MostrarInfoPerfil;
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

En MySQL existen cinco niveles distintos de privilegios:
* Globales: se aplican al conjunto de todas las bases de datos en un servidor. Es el nivel más alto de privilegio, en el sentido de que su ámbito es el más general.
* De base de datos: se refieren a bases de datos individuales, y por extensión, a todos los objetos que contiene cada base de datos.
* De tabla: se aplican a tablas individuales, y por lo tanto, a todas las columnas de esas tabla.
* De columna: se aplican a una columna en una tabla concreta.
* De rutina: se aplican a los procedimientos almacenados. Aún no hemos visto nada sobre este tema, pero en MySQL se pueden almacenar procedimietos consistentes en varias consultas SQL.

**Privilegios:**
```shell
MariaDB [information_schema]> show privileges;
+-------------------------+---------------------------------------+-------------------------------------------------------+
| Privilege               | Context                               | Comment                                               |
+-------------------------+---------------------------------------+-------------------------------------------------------+
| Alter                   | Tables                                | To alter the table                                    |
| Alter routine           | Functions,Procedures                  | To alter or drop stored functions/procedures          |
| Create                  | Databases,Tables,Indexes              | To create new databases and tables                    |
| Create routine          | Databases                             | To use CREATE FUNCTION/PROCEDURE                      |
| Create temporary tables | Databases                             | To use CREATE TEMPORARY TABLE                         |
| Create view             | Tables                                | To create new views                                   |
| Create user             | Server Admin                          | To create new users                                   |
| Delete                  | Tables                                | To delete existing rows                               |
| Delete versioning rows  | Tables                                | To delete versioning table historical rows            |
| Drop                    | Databases,Tables                      | To drop databases, tables, and views                  |
| Event                   | Server Admin                          | To create, alter, drop and execute events             |
| Execute                 | Functions,Procedures                  | To execute stored routines                            |
| File                    | File access on server                 | To read and write files on the server                 |
| Grant option            | Databases,Tables,Functions,Procedures | To give to other users those privileges you possess   |
| Index                   | Tables                                | To create or drop indexes                             |
| Insert                  | Tables                                | To insert data into tables                            |
| Lock tables             | Databases                             | To use LOCK TABLES (together with SELECT privilege)   |
| Process                 | Server Admin                          | To view the plain text of currently executing queries |
| Proxy                   | Server Admin                          | To make proxy user possible                           |
| References              | Databases,Tables                      | To have references on tables                          |
| Reload                  | Server Admin                          | To reload or refresh tables, logs and privileges      |
| Replication client      | Server Admin                          | To ask where the slave or master servers are          |
| Replication slave       | Server Admin                          | To read binary log events from the master             |
| Select                  | Tables                                | To retrieve rows from table                           |
| Show databases          | Server Admin                          | To see all databases with SHOW DATABASES              |
| Show view               | Tables                                | To see views with SHOW CREATE VIEW                    |
| Shutdown                | Server Admin                          | To shut down the server                               |
| Super                   | Server Admin                          | To use KILL thread, SET GLOBAL, CHANGE MASTER, etc.   |
| Trigger                 | Tables                                | To use triggers                                       |
| Create tablespace       | Server Admin                          | To create/alter/drop tablespaces                      |
| Update                  | Tables                                | To update existing rows                               |
| Usage                   | Server Admin                          | No privileges - allow connect only                    |
+-------------------------+---------------------------------------+-------------------------------------------------------+
32 rows in set (0.001 sec)
```

* Para asignar privilegios a un usuario:
```shell
GRANT "privilegio" ON *.* TO "nombre_usuario"@"localhost" identified by "contraseña".
```

* Si queremos que al usuario al cuál hemos asignado un privilegio pueda asignarlo a su vez a otro usuario ejecutaremos:
```shell
GRANT "privilegio" ON *.* TO "nombre_usuario"@"localhost" identified by "contraseña" with grant option;
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