---------------------------------------------------
---------Creacion de logins del servidor-----------


USE master;
GO

-- LOGIN DEL ADMINISTRADOR

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_principals
    WHERE name = 'login_admin'
)
BEGIN
    CREATE LOGIN login_admin
    WITH PASSWORD = 'Admin_Gym2026#',
    CHECK_POLICY = ON;
END;
GO

-- LOGIN DE RECEPCION

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_principals
    WHERE name = 'login_recepcion'
)
BEGIN
    CREATE LOGIN login_recepcion
    WITH PASSWORD = 'Recepcion_Gym2026#',
    CHECK_POLICY = ON;
END;
GO

-- LOGIN DEL ENTRENADOR

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_principals
    WHERE name = 'login_entrenador'
)
BEGIN
    CREATE LOGIN login_entrenador
    WITH PASSWORD = 'Entrenador_Gym2026#',
    CHECK_POLICY = ON;
END;
GO

-- LOGIN DEL SOCIO

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_principals
    WHERE name = 'login_socio'
)
BEGIN
    CREATE LOGIN login_socio
    WITH PASSWORD = 'Socio_Gym2026#',
    CHECK_POLICY = ON;
END;
GO

-- VERIFICACION DE LOGINS

SELECT
    name AS NombreLogin,
    type_desc AS Tipo
FROM sys.server_principals
WHERE name LIKE 'login_%';
GO
