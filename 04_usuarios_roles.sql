------------------------------------------------
---------Creacion de usuarios y roles-----------


USE Gimnasio_Reserva;
GO

-- CREACION DE USUARIOS

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals
    WHERE name = 'usuario_admin'
)
    CREATE USER usuario_admin FOR LOGIN login_admin;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals
    WHERE name = 'usuario_recepcion'
)
    CREATE USER usuario_recepcion FOR LOGIN login_recepcion;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals
    WHERE name = 'usuario_entrenador'
)
    CREATE USER usuario_entrenador FOR LOGIN login_entrenador;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals
    WHERE name = 'usuario_socio'
)
    CREATE USER usuario_socio FOR LOGIN login_socio;
GO


-- CREACION DE ROLES

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals
    WHERE name = 'rol_admin' AND type = 'R'
)
    CREATE ROLE rol_admin;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals
    WHERE name = 'rol_recepcion' AND type = 'R'
)
    CREATE ROLE rol_recepcion;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals
    WHERE name = 'rol_entrenador' AND type = 'R'
)
    CREATE ROLE rol_entrenador;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals
    WHERE name = 'rol_socio' AND type = 'R'
)
    CREATE ROLE rol_socio;
GO


-- ASIGNACION DE USUARIOS A ROLES

ALTER ROLE rol_admin
ADD MEMBER usuario_admin;
GO

ALTER ROLE rol_recepcion
ADD MEMBER usuario_recepcion;
GO

ALTER ROLE rol_entrenador
ADD MEMBER usuario_entrenador;
GO

ALTER ROLE rol_socio
ADD MEMBER usuario_socio;
GO


-- VERIFICACION DE USUARIOS Y ROLES

SELECT
    R.name AS NombreRol,
    U.name AS NombreUsuario
FROM sys.database_role_members RM
INNER JOIN sys.database_principals R
    ON RM.role_principal_id = R.principal_id
INNER JOIN sys.database_principals U
    ON RM.member_principal_id = U.principal_id
WHERE R.name LIKE 'rol_%';
GO
