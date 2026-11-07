------------------------------------------
---------Asignacion de permisos-----------


USE Gimnasio_Reserva;
GO

-- ADMINISTRADOR: CONTROL TOTAL

GRANT CONTROL
ON DATABASE::Gimnasio_Reserva
TO rol_admin;
GO

-- RECEPCION

-- Gestionar socios 
GRANT SELECT, INSERT, UPDATE
ON dbo.Socio TO rol_recepcion;
GO

-- Gestionar reservas
GRANT SELECT, INSERT, UPDATE
ON dbo.Reserva TO rol_recepcion;
GO

-- Gestionar pagos
GRANT SELECT, INSERT, UPDATE
ON dbo.Pago TO rol_recepcion;
GO

-- Consultar clases
GRANT SELECT
ON dbo.Clases TO rol_recepcion;
GO

-- Consultar programaciones
GRANT SELECT
ON dbo.Programacion_clase TO rol_recepcion;
GO

-- Consultar entrenadores
GRANT SELECT
ON dbo.Entrenador TO rol_recepcion;
GO

-- ENTRENADOR

-- Consultar clases
GRANT SELECT
ON dbo.Clases TO rol_entrenador;
GO

-- Consultar programaciones
GRANT SELECT
ON dbo.Programacion_clase TO rol_entrenador;
GO

-- Consultar entrenadores
GRANT SELECT
ON dbo.Entrenador TO rol_entrenador;
GO

-- SOCIO

-- Consultar clases
GRANT SELECT
ON dbo.Clases TO rol_socio;
GO

-- Consultar programaciones
GRANT SELECT
ON dbo.Programacion_clase TO rol_socio;
GO
