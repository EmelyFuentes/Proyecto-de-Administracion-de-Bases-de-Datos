--Job del backup completo 
BACKUP DATABASE Gimnasio_Reserva
TO DISK = '/var/opt/mssql/backup/Gimnasio_full.bak'
WITH FORMAT, INIT,
NAME = 'Backup Completo Gimnasio';
--Sucede de manera diaria a las 10:00 PM cada día

--Job del backup diferencial
BACKUP DATABASE Gimnasio_Reserva
TO DISK = '/var/opt/mssql/backup/Gimnasio_full.bak'
WITH FORMAT, INIT,
NAME = 'Backup Completo Gimnasio';
--Sucede de manera diaria a las 12:00 AM

--Job del Backup Log
BACKUP LOG Gimnasio_Reserva
TO DISK = '/var/opt/mssql/backup/Gimnasio_log.trn'
WITH INIT,
NAME = 'Backup del log de Gimnasio';
--Sucede cada hora 