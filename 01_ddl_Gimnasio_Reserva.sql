-----------------------------------------------------------
-------------Diseño fisico de la base de datos-------------


--Creacion de la base de datos
CREATE DATABASE Gimnasio_Reserva;
GO

USE Gimnasio_Reserva
GO

-- 1. Tabla Socio
CREATE TABLE Socio (
    id_socio       INT IDENTITY(1,1),
    dui            VARCHAR(10) UNIQUE NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    apellido       VARCHAR(100) NOT NULL,
    fecha_registro DATE NOT NULL CONSTRAINT df_socio_fecha DEFAULT (GETDATE()),
    telefono       VARCHAR(15)

    CONSTRAINT pk_socio PRIMARY KEY (id_socio),
    CONSTRAINT uq_socio_DUI UNIQUE (dui),
    CONSTRAINT ck_socio_dui CHECK (dui LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'),
);

-- 2. Tabla Entrenador
CREATE TABLE Entrenador (
    id_entrenador INT IDENTITY(1,1) NOT NULL,
    nombre        VARCHAR(100) NOT NULL,
    apellido      VARCHAR(100) NOT NULL,
    telefono      VARCHAR(15),
    especialidad  VARCHAR(100) NOT NULL,

    CONSTRAINT pk_entrenador PRIMARY KEY (id_entrenador)
);

-- 3. Tabla Clases
CREATE TABLE Clases (
    id_clase INT IDENTITY(1,1) NOT NULL,
    nombre_clase VARCHAR(100) NOT NULL,
    capacidad INT NOT NULL,
    descripcion VARCHAR(500),

    CONSTRAINT pk_clases PRIMARY KEY (id_clase),
    CONSTRAINT ck_clases_Capacidad CHECK (capacidad > 0)
);

-- 4. Tabla Programacion_clase
CREATE TABLE Programacion_clase (
    id_programacion   INT IDENTITY(1,1) NOT NULL,
    hora_fin          TIME NOT NULL,
    hora_inicio       TIME NOT NULL,
    cupos_disponibles INT NOT NULL,
    fecha             DATE NOT NULL,
    id_entrenador     INT NOT NULL,
    id_clase          INT NOT NULL,

    CONSTRAINT pk_programacion_clase PRIMARY KEY (id_programacion),
    CONSTRAINT ck_programacion_horario CHECK (hora_fin > hora_inicio),
    CONSTRAINT ck_programacion_cupos CHECK (cupos_disponibles >= 0),
    CONSTRAINT fk_programacion_entrenador 
        FOREIGN KEY (id_entrenador) 
        REFERENCES Entrenador(id_entrenador)
    ON UPDATE CASCADE,
    CONSTRAINT fk_programacion_clases
        FOREIGN KEY (id_clase) 
        REFERENCES Clases(id_clase)
    ON UPDATE CASCADE
);

-- 5. Tabla Reserva
CREATE TABLE Reserva (
    id_reserva      INT IDENTITY(1,1) NOT NULL,
    estado_reserva  VARCHAR(30) NOT NULL,
    fecha_reserva DATE NOT NULL
    CONSTRAINT df_reserva_fecha DEFAULT (GETDATE()),
    id_socio        INT NOT NULL,
    id_programacion INT NOT NULL,

    CONSTRAINT pk_reserva PRIMARY KEY (id_reserva),
    CONSTRAINT ck_reserva_estado CHECK (estado_reserva IN ('PENDIENTE', 'CONFIRMADA', 'CANCELADA')),
    CONSTRAINT uq_reserva_socio_programacion UNIQUE (id_socio, id_programacion),
    CONSTRAINT fk_reserva_socio 
        FOREIGN KEY (id_socio) 
        REFERENCES Socio(id_socio)
    ON UPDATE CASCADE,
    CONSTRAINT fk_reserva_programacion 
        FOREIGN KEY (id_programacion) 
        REFERENCES Programacion_clase(id_programacion)
    ON UPDATE CASCADE
);


-- 6. Tabla Pago
CREATE TABLE Pago (
    id_pago    INT IDENTITY(1,1) NOT NULL,
    monto      DECIMAL(10,2) NOT NULL,
    fecha_pago DATE NOT NULL
    CONSTRAINT df_pago_fecha DEFAULT (GETDATE()),
    razon      VARCHAR(150) NOT NULL,
    forma_pago VARCHAR(50) NOT NULL,
    id_socio   INT NOT NULL,

   CONSTRAINT pk_pago PRIMARY KEY (id_pago),
   CONSTRAINT ck_pago_monto CHECK (monto >= 0),
   CONSTRAINT ck_pago_forma CHECK (forma_pago IN ('EFECTIVO', 'TARJETA', 'TRANSFERENCIA')),
   CONSTRAINT FK_pago_socio 
        FOREIGN KEY (id_socio) 
        REFERENCES Socio(id_socio)
   ON UPDATE CASCADE
);