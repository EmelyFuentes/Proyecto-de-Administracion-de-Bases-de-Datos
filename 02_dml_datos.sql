----------------------------------
---------Carga de datos-----------

USE Gimnasio_Reserva;
GO

INSERT INTO Socio (dui, nombre, apellido, fecha_registro, telefono) VALUES
('12345678-2', 'Ana', 'Rivas', '2025-01-15', '70002345'),
('23456789-3', 'Roberto', 'Hernandez', '2025-02-01', '70003456'),
('34567890-4', 'Maria', 'Castro', '2025-02-12', '70004567'),
('45678901-5', 'Jose', 'Mendoza', '2025-03-05', '70005678'),
('56789012-6', 'Sofia', 'Arevalo', '2025-03-18', '70006789'),
('67890123-7', 'Daniel', 'Garcia', '2025-04-02', '70007890'),
('78901234-8', 'Laura', 'Navarro', '2025-04-20', '70008901'),
('89012345-9', 'Fernando', 'Ramos', '2025-05-11', '70009012'),
('90123456-0', 'Gabriela', 'Torres', '2025-05-25', '70000123');
GO

INSERT INTO Entrenador (nombre, apellido, telefono, especialidad) VALUES
('Carlos', 'Linares', '71000001', 'Musculacion'),
('Ariana', 'Lopez', '71000002', 'Yoga'),
('Ronald', 'Villalta', '71000003', 'Crossfit'),
('Marta', 'Campos', '71000004', 'Pilates'),
('Jonathan', 'Alvarado', '71000005', 'Cardio'),
('Sara', 'Delgado', '71000006', 'Zumba'),
('Daniel', 'Acevedo', '71000007', 'Boxeo'),
('Lisa', 'Mendoza', '71000008', 'Spinning');
GO

INSERT INTO Clases (nombre_clase, capacidad, descripcion) VALUES
('Musculacion', 20, 'Entrenamiento de fuerza y resistencia'),
('Yoga', 15, 'Ejercicios de flexibilidad y relajacion'),
('Crossfit', 18, 'Entrenamiento funcional de alta intensidad'),
('Pilates', 12, 'Control corporal y fortalecimiento'),
('Cardio', 25, 'Ejercicios cardiovasculares'),
('Zumba', 22, 'Baile y acondicionamiento fisico'),
('Boxeo', 16, 'Entrenamiento de boxeo'),
('Spinning', 20, 'Ciclismo en bicicletas estacionarias');
GO

INSERT INTO Programacion_clase (hora_inicio, hora_fin, cupos_disponibles, fecha, id_entrenador, id_clase) VALUES
('06:00', '07:00', 18, '2026-11-06', 1, 1),
('07:00', '08:00', 12, '2026-11-06', 2, 2),
('08:00', '09:00', 20, '2026-11-06', 3, 3),
('09:00', '10:00', 10, '2026-11-06', 4, 4),
('10:00', '11:00', 13, '2026-11-06', 5, 5),
('16:00', '17:00', 15, '2026-11-07', 6, 1),
('17:00', '18:00', 10, '2026-11-07', 7, 2),
('18:00', '19:00', 22, '2026-11-07', 8, 3),
('07:00', '08:00', 8, '2026-11-08', 1, 4),
('08:00', '09:00', 12, '2026-11-08', 2, 5);
GO

INSERT INTO Reserva (estado_reserva, fecha_reserva, id_socio, id_programacion) VALUES
('CONFIRMADA', '2026-11-01', 1, 1),
('PENDIENTE',  '2026-11-01', 2, 2),
('CONFIRMADA', '2026-11-02', 3, 3),
('CANCELADA',  '2026-11-02', 4, 4),
('CONFIRMADA', '2026-11-02', 5, 5),
('PENDIENTE',  '2026-11-03', 6, 6),
('CONFIRMADA', '2026-11-03', 7, 7),
('CONFIRMADA', '2026-11-03', 8, 8),
('CANCELADA',  '2026-11-04', 1, 9),
('CONFIRMADA', '2026-11-04', 2, 10),
('PENDIENTE',  '2026-11-04', 3, 1),
('CONFIRMADA', '2026-11-04', 4, 2),
('CONFIRMADA', '2026-11-05', 5, 3),
('CANCELADA',  '2026-11-05', 6, 4),
('CONFIRMADA', '2026-11-05', 7, 5);
GO

INSERT INTO Pago (monto, fecha_pago, razon, forma_pago, id_socio) VALUES
(25.00, '2026-11-01', 'Mensualidad', 'EFECTIVO', 1),
(30.00, '2026-11-01', 'Inscripcion', 'TARJETA', 2),
(25.00, '2026-11-02', 'Mensualidad', 'TRANSFERENCIA', 3),
(15.00, '2026-11-02', 'Clase adicional', 'EFECTIVO', 4),
(25.00, '2026-11-03', 'Mensualidad', 'TARJETA', 5),
(30.00, '2026-11-03', 'Inscripcion', 'TRANSFERENCIA', 6),
(25.00, '2026-11-04', 'Mensualidad', 'EFECTIVO', 7),
(15.00, '2026-11-04', 'Clase adicional', 'TARJETA', 8);
GO