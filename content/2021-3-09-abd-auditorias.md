---
date: 2021-03-09
title: "[ABD] Práctica 7 - Auditorías"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - ABD
tags:
    - Auditorías
---

<center><img alt="Auditorías base de datos" src="https://miro.medium.com/max/413/1*z2Q0z24IbwF1RLPa4X6glw.png"/></center>

Realiza y documenta adecuadamente las siguientes operaciones:

1. Activa desde SQL*Plus la auditoría de los intentos de acceso fallidos al sistema. Comprueba su funcionamiento. 

Visualizaremos los parametros de auditorias.
```shell
SQL> SHOW PARAMETER AUDIT

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
audit_file_dest 		     string	 /opt/oracle/admin/ORCL/adump
audit_sys_operations		     boolean	 FALSE
audit_syslog_level		     string
audit_trail			     string	 NONE
unified_audit_sga_queue_size	     integer	 1048576
```

Activamos audit_trail:
```shell
SQL> ALTER SYSTEM SET audit_trail=db scope=spfile;

System altered.
```

Reiniciaremos Oracle.
```shell
SQL> SHUTDOWN
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> STARTUP
ORACLE instance started.

Total System Global Area  629145600 bytes
Fixed Size		    8623832 bytes
Variable Size		  524290344 bytes
Database Buffers	   88080384 bytes
Redo Buffers		    8151040 bytes
Database mounted.
Database opened.
SQL> ALTER SESSION SET "_ORACLE_SCRIPT"=true;

Session altered.

SQL> SHOW PARAMETER AUDIT

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
audit_file_dest 		     string	 /opt/oracle/admin/ORCL/adump
audit_sys_operations		     boolean	 FALSE
audit_syslog_level		     string
audit_trail			     string	 DB
unified_audit_sga_queue_size	     integer	 1048576
```

Activamos la auditoria.
```shell
SQL> AUDIT CREATE SESSION WHENEVER NOT SUCCESSFUL;

Audit succeeded.
```

Comprobamos su activación.
```shell
SQL> AUDIT CREATE SESSION BY fran;      

Audit succeeded.

SQL> SELECT * FROM DBA_PRIV_AUDIT_OPTS;

USER_NAME
--------------------------------------------------------------------------------
PROXY_NAME
--------------------------------------------------------------------------------
PRIVILEGE				 SUCCESS    FAILURE
---------------------------------------- ---------- ----------


CREATE SESSION				 NOT SET    BY ACCESS

FRAN

CREATE SESSION				 BY ACCESS  BY ACCESS

USER_NAME
--------------------------------------------------------------------------------
PROXY_NAME
--------------------------------------------------------------------------------
PRIVILEGE				 SUCCESS    FAILURE
---------------------------------------- ---------- ----------
```

Probaremos la auditoria, intentando acceceder a nuestra base de datos.
```shell
[oracle@oracle1 ~]$ sqlplus

SQL*Plus: Release 12.2.0.1.0 Production on Tue Mar 9 17:13:05 2021

Copyright (c) 1982, 2016, Oracle.  All rights reserved.

Enter user-name: fran
Enter password: 
ERROR:
ORA-01017: invalid username/password; logon denied


Enter user-name: fran
Enter password: 
ERROR:
ORA-01017: invalid username/password; logon denied


Enter user-name: sys
Enter password: 
ERROR:
ORA-28009: connection as SYS should be as SYSDBA or SYSOPER


SP2-0157: unable to CONNECT to ORACLE after 3 attempts, exiting SQL*Plus
```

Visualizaremos los accesos fallidos.
```shell
SQL> SELECT OS_USERNAME, USERNAME, EXTENDED_TIMESTAMP, ACTION_NAME, RETURNCODE
  2  FROM DBA_AUDIT_SESSION;

OS_USERNAME
--------------------------------------------------------------------------------
USERNAME
--------------------------------------------------------------------------------
EXTENDED_TIMESTAMP
---------------------------------------------------------------------------
ACTION_NAME		     RETURNCODE
---------------------------- ----------
oracle
FRAN
09-MAR-21 05.12.49.102118 PM -03:00
LOGON				      0


OS_USERNAME
--------------------------------------------------------------------------------
USERNAME
--------------------------------------------------------------------------------
EXTENDED_TIMESTAMP
---------------------------------------------------------------------------
ACTION_NAME		     RETURNCODE
---------------------------- ----------
oracle
FRAN
09-MAR-21 05.13.09.178910 PM -03:00
LOGON				   1017


OS_USERNAME
--------------------------------------------------------------------------------
USERNAME
--------------------------------------------------------------------------------
EXTENDED_TIMESTAMP
---------------------------------------------------------------------------
ACTION_NAME		     RETURNCODE
---------------------------- ----------
oracle
FRAN
09-MAR-21 05.13.13.252421 PM -03:00
LOGON				   1017


OS_USERNAME
--------------------------------------------------------------------------------
USERNAME
--------------------------------------------------------------------------------
EXTENDED_TIMESTAMP
---------------------------------------------------------------------------
ACTION_NAME		     RETURNCODE
---------------------------- ----------
oracle
FRAN
09-MAR-21 05.13.03.893419 PM -03:00
LOGOFF				      0
```

Para finalizar, desactivaremos la auditoría.
```shell
SQL> NOAUDIT CREATE SESSION WHENEVER NOT SUCCESSFUL;

Noaudit succeeded.
```

2. Realiza un procedimiento en PL/SQL que te muestre los accesos fallidos junto con el motivo de los mismos, transformando el código de error almacenado en un mensaje de texto comprensible.

Función para devolver el motivo del error:
```shell
CREATE OR REPLACE FUNCTION DevolverMotivo
(
    p_error NUMBER
)
RETURN VARCHAR2
IS
    mensaje VARCHAR2(25);
BEGIN
    CASE p_error
        WHEN 1017 THEN 
            mensaje:='Contraseña Incorrecta';
        WHEN 28000 THEN
            mensaje:='Cuenta Bloqueada';
        ELSE
            mensaje:='Error Desconocido';
    END CASE;
RETURN mensaje;
END DevolverMotivo;
/

Function created.
```

Procedimiento:
```shell
CREATE OR REPLACE PROCEDURE MostrarAccesosFallidos
IS
    CURSOR c_accesos
    IS 
    SELECT username, returncode, timestamp
    FROM dba_audit_session 
    WHERE action_name='LOGON' 
    AND returncode != 0 
    ORDER BY timestamp;

    v_motivo VARCHAR2(25);
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10)||CHR(9)||CHR(9)||'-- AUDITORÍA DE ACCESOS FALLIDOS --');
    DBMS_OUTPUT.PUT_LINE(CHR(10)||CHR(9)||'USUARIO'||CHR(9)||CHR(9)||'FECHA'||CHR(9)||CHR(9)||CHR(9)||
        'MOTIVO');
    DBMS_OUTPUT.PUT_LINE(CHR(9)||'----------------------------------------------------------------');
    FOR acceso IN c_accesos LOOP
        v_motivo:=DevolverMotivo(acceso.returncode);
        DBMS_OUTPUT.PUT_LINE(CHR(10)||CHR(9)||acceso.username||CHR(9)||CHR(9)||
            TO_CHAR(acceso.timestamp,'YY/MM/DD DY HH24:MI')||CHR(9)||v_motivo);
    END LOOP; 
END MostrarAccesosFallidos;
/
```

3. Activa la auditoría de las operaciones DML realizadas por SCOTT. Comprueba su funcionamiento.

Activamos la auditoría.
```shell
AUDIT INSERT TABLE, UPDATE TABLE, DELETE TABLE BY SCOTT BY ACCESS;
```

Donde:
* BY ACCESS : Realiza un registro por cada acción.
* BY SESSION : Realiza un registro de todas las acciones por cada sesión iniciada.

Realizamos una prueba:
```shell
SQL> CONN SCOTT/TIGER
Connected.
SQL> INSERT INTO dept VALUES(50,'RRHH','Dos Hermanas');

1 row created.

SQL> UPDATE dept SET loc='Sevilla' WHERE deptno=50;

1 row updated.

SQL> DELETE FROM dept WHERE deptno=50;

1 row deleted.

SQL> COMMIT;

Commit complete.
```

Para ver las acciones realizadas por SCOTT:
```shell
SELECT obj_name, action_name, timestamp
FROM dba_audit_object
WHERE username='SCOTT';
```

```shell
SQL> SELECT obj_name, action_name, timestamp
  2  FROM dba_audit_object
  3  WHERE username='SCOTT';

OBJ_NAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAMP
---------------------------- ---------
SDO_GEOR_DDL__TABLE$$
INSERT			     10-MAR-21

SDO_GEOR_DDL__TABLE$$
INSERT			     10-MAR-21

SDO_GEOR_DDL__TABLE$$
INSERT			     10-MAR-21


OBJ_NAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAMP
---------------------------- ---------
SDO_GEOR_DDL__TABLE$$
INSERT			     10-MAR-21

SDO_GEOR_DDL__TABLE$$
INSERT			     10-MAR-21

EMP
INSERT			     10-MAR-21


OBJ_NAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAMP
---------------------------- ---------
EMP
INSERT			     10-MAR-21

EMP
INSERT			     10-MAR-21

EMP
INSERT			     10-MAR-21


OBJ_NAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAMP
---------------------------- ---------
EMP
INSERT			     10-MAR-21

EMP
INSERT			     10-MAR-21

EMP
INSERT			     10-MAR-21


OBJ_NAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAMP
---------------------------- ---------
EMP
INSERT			     10-MAR-21

EMP
INSERT			     10-MAR-21

EMP
INSERT			     10-MAR-21


OBJ_NAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAMP
---------------------------- ---------
EMP
INSERT			     10-MAR-21

EMP
INSERT			     10-MAR-21

EMP
INSERT			     10-MAR-21


OBJ_NAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAMP
---------------------------- ---------
EMP
INSERT			     10-MAR-21

DEPT
INSERT			     10-MAR-21

DEPT
INSERT			     10-MAR-21


OBJ_NAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAMP
---------------------------- ---------
DEPT
INSERT			     10-MAR-21

DEPT
INSERT			     10-MAR-21

SALGRADE
INSERT			     10-MAR-21


OBJ_NAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAMP
---------------------------- ---------
SALGRADE
INSERT			     10-MAR-21

SALGRADE
INSERT			     10-MAR-21

SALGRADE
INSERT			     10-MAR-21


OBJ_NAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAMP
---------------------------- ---------
SALGRADE
INSERT			     10-MAR-21

DUMMY
INSERT			     10-MAR-21

DEPT
INSERT			     10-MAR-21


OBJ_NAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAMP
---------------------------- ---------
DEPT
INSERT			     10-MAR-21

DEPT
INSERT			     10-MAR-21

DEPT
UPDATE			     10-MAR-21


OBJ_NAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAMP
---------------------------- ---------
DEPT
DELETE			     10-MAR-21


34 rows selected.
```

En mi caso ha bastantes salidas puesto que he añadido al usuario SCOTT y su esquema a la base de datos ahora mismo.
[Pasos a seguir para añadir el usuario SCOTT a tu base de datos Oracle](http://www.tecnoent.com/838-creando-esquema-scott-tiger-oracl).



4. Realiza una auditoría de grano fino para almacenar información sobre la inserción de empleados del departamento 10 en la tabla emp de scott.

Creación de la auditoría de grano fino:
```shell
SQL> BEGIN
    DBMS_FGA.ADD_POLICY (
        object_schema      =>  'SCOTT',
        object_name        =>  'EMP',
        policy_name        =>  'mypolicy1',
        audit_condition    =>  'DEPTNO = 10',
        statement_types    =>  'INSERT'
    );
END;
/ 

PL/SQL procedure successfully completed.
```

Ver la política creada:
```shell
SQL> SELECT object_schema,object_name,policy_name,policy_text
  2  FROM dba_audit_policies;

OBJECT_SCHEMA
--------------------------------------------------------------------------------
OBJECT_NAME
--------------------------------------------------------------------------------
POLICY_NAME
--------------------------------------------------------------------------------
POLICY_TEXT
--------------------------------------------------------------------------------
SCOTT
EMP
MYPOLICY1
DEPTNO = 10
```

Realizamos una prueba:
```shell
CONN SCOTT/TIGER

INSERT INTO emp VALUES(7950,'Lora','JEFE',null,sysdate,9999,9999,10);
INSERT INTO emp VALUES(7951,'Calde','PROFE',null,sysdate,9999,9999,10);

COMMIT;
```

5. Explica la diferencia entre auditar una operación by access o by session.

6. Documenta las diferencias entre los valores db y db, extended del parámetro audit_trail de ORACLE. Demuéstralas poniendo un ejemplo de la información sobre una operación concreta recopilada con cada uno de ellos.

7. Localiza en Enterprise Manager las posibilidades para realizar una auditoría e intenta repetir con dicha herramienta los apartados 1, 3 y 4.

8. Averigua si en Postgres se pueden realizar los apartados 1, 3 y 4. Si es así, documenta el proceso adecuadamente.

9. Averigua si en MySQL se pueden realizar los apartados 1, 3 y 4. Si es así, documenta el proceso adecuadamente.

10.  Averigua las posibilidades que ofrece MongoDB para auditar los cambios que va sufriendo un documento.

11.  Averigua si en MongoDB se pueden auditar los accesos al sistema.