use master;
go

--si la base de datos existe la elimina o remplaza
if db_id('Gimnasio_Reserva') is not null
begin
    alter database Gimnasio_Reserva set single_user with rollback immediate;
end
go

--restaurar el backup full dejando la base en estado de espera
restore database Gimnasio_Reserva
from disk = '/var/opt/mssql/backup/Gimnasio_full.bak'
with norecovery, replace;
go

--restaurar el backup diferencial siempre en estado de espera 
restore database Gimnasio_Reserva
from disk = '/var/opt/mssql/backup/Gimnasio_diff.bak'
with norecovery;
go

--se usa norecovery porque aun falta el ultimo archivo por restaurar 

--restaurar el backup del log y habilitar la base de datos 
restore log Gimnasio_Reserva
from disk = '/var/opt/mssql/backup/Gimnasio_log.trn'
with recovery;
go

--asegurar el acceso multiusuario normal
alter database Gimnasio_Reserva set multi_user;
go
