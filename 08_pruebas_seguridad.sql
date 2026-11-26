---------------------------------------
---------Pruebas y verificacion--------


USE Gimnasio_Reserva;
GO

-- VERIFICAR USUARIOS

SELECT
    name AS NombreUsuario,
    type_desc AS TipoUsuario
FROM sys.database_principals
WHERE name LIKE 'usuario_%';
GO

-- VERIFICAR ROLES

SELECT
    name AS NombreRol
FROM sys.database_principals
WHERE name LIKE 'rol_%'
AND type = 'R';
GO

-- VERIFICAR ASIGNACIONES

SELECT
    R.name AS Rol,
    U.name AS Usuario
FROM sys.database_role_members RM
INNER JOIN sys.database_principals R
    ON RM.role_principal_id = R.principal_id
INNER JOIN sys.database_principals U
    ON RM.member_principal_id = U.principal_id
WHERE R.name LIKE 'rol_%';
GO

-- PRUEBAS DE RECEPCION

EXECUTE AS USER = 'usuario_recepcion';

SELECT
    'Recepcion' AS Usuario,
    HAS_PERMS_BY_NAME(
        'dbo.Socio', 'OBJECT', 'SELECT'
    ) AS ConsultarSocios,
    HAS_PERMS_BY_NAME(
        'dbo.Pago', 'OBJECT', 'INSERT'
    ) AS RegistrarPagos,
    HAS_PERMS_BY_NAME(
        'dbo.Pago', 'OBJECT', 'DELETE'
    ) AS EliminarPagos;

REVERT;
GO

-- PRUEBAS DEL ENTRENADOR

EXECUTE AS USER = 'usuario_entrenador';

SELECT
    'Entrenador' AS Usuario,
    HAS_PERMS_BY_NAME(
        'dbo.Clases', 'OBJECT', 'SELECT'
    ) AS ConsultarClases,
    HAS_PERMS_BY_NAME(
        'dbo.Clases', 'OBJECT', 'UPDATE'
    ) AS ModificarClases,
    HAS_PERMS_BY_NAME(
        'dbo.Pago', 'OBJECT', 'SELECT'
    ) AS ConsultarPagos;

REVERT;
GO

-- PRUEBAS DEL SOCIO

EXECUTE AS USER = 'usuario_socio';

SELECT
    'Socio' AS Usuario,
    HAS_PERMS_BY_NAME(
        'dbo.Clases', 'OBJECT', 'SELECT'
    ) AS ConsultarClases,
    HAS_PERMS_BY_NAME(
        'dbo.Pago', 'OBJECT', 'SELECT'
    ) AS ConsultarPagos,
    HAS_PERMS_BY_NAME(
        'dbo.Socio', 'OBJECT', 'SELECT'
    ) AS ConsultarDatosSocios;

REVERT;
GO

-- VERIFICAR AUDITORIA DEL SERVIDOR

USE master;
GO

SELECT
    name AS Auditoria,
    is_state_enabled AS Activa
FROM sys.server_audits
WHERE name = 'AuditoriaGimnasio';
GO

-- VERIFICAR AUDITORIA DE LA BASE

USE Gimnasio_Reserva;
GO

SELECT
    name AS Especificacion,
    is_state_enabled AS Activa
FROM sys.database_audit_specifications
WHERE name = 'AuditoriaSeguridadGimnasio';
GO

-- CONSULTAR REGISTROS DE AUDITORIA

SELECT
    event_time,
    action_id,
    succeeded,
    server_principal_name,
    database_principal_name,
    statement
FROM sys.fn_get_audit_file(
    '/var/opt/mssql/audit/*.sqlaudit',
    DEFAULT,
    DEFAULT
)
ORDER BY event_time DESC;
GO
