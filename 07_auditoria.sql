---------------------------------------
---------Auditoria de seguridad--------

USE master;
GO

-- CREACION DE AUDITORIA

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_audits
    WHERE name = 'AuditoriaGimnasio'
)
BEGIN
    CREATE SERVER AUDIT AuditoriaGimnasio
    TO FILE
    (
        FILEPATH = '/var/opt/mssql/audit/'
    );
END;
GO

-- ACTIVAR AUDITORIA

ALTER SERVER AUDIT AuditoriaGimnasio
WITH (STATE = ON);
GO


-- ESPECIFICACION DE AUDITORIA

USE Gimnasio_Reserva;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_audit_specifications
    WHERE name = 'AuditoriaSeguridadGimnasio'
)
BEGIN
    CREATE DATABASE AUDIT SPECIFICATION
    AuditoriaSeguridadGimnasio
    FOR SERVER AUDIT AuditoriaGimnasio

    ADD (DATABASE_OBJECT_ACCESS_GROUP),
    ADD (DATABASE_PRINCIPAL_CHANGE_GROUP),
    ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP);
END;
GO

-- ACTIVAR ESPECIFICACION

ALTER DATABASE AUDIT SPECIFICATION
AuditoriaSeguridadGimnasio
WITH (STATE = ON);
GO
