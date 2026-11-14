use Gimnasio_Reserva;
go

-- ver el estado actual, espacio usado y libre, y el crecimiento de cada archivo
select name,
type_desc,size*8/1024.0 as tamano_mb,fileproperty(name,'spaceused')*8/1024.0 as usado_mb,(size-fileproperty(name,'spaceused'))*8/1024.0 
as libre_mb,
case when is_percent_growth=1 
then concat(growth,'%') 
else concat(growth*8/1024,' MB') 
end as crecimiento,max_size 
from sys.database_files;

--espacio por tabla, de mayor a menor
select s.name+'.'+t.name as tabla,sum(case when p.index_id<2 then p.row_count end) 
as filas,sum(p.used_page_count)*8 as usado_kb,sum(p.reserved_page_count)*8 
as reservado_kb 
from sys.dm_db_partition_stats p join sys.tables t on t.object_id=p.object_id join sys.schemas s 
on s.schema_id=t.schema_id group by s.name,t.name 
order by reservado_kb desc;

--proyeccion del crecimiento de datos
declare @crec decimal(5,2)=0.10,@meses int=12; -- supuestos: 10% de crecimiento mensual, 12 meses
with t as (select sum(reserved_page_count)*8/1024.0 as datos_mb 
from sys.dm_db_partition_stats 
where object_id in (select object_id from sys.tables)),a as (select sum(fileproperty(name,'spaceused'))*8/1024.0 as usado_mb 
from sys.database_files where type=0) 
select cast(a.usado_mb as decimal(10,2)) as usado_mb,
cast(t.datos_mb as decimal(10,2)) as datos_usuario_mb,
cast(a.usado_mb-t.datos_mb as decimal(10,2)) as base_fija_mb,
cast(a.usado_mb-t.datos_mb+t.datos_mb*power(1+@crec,@meses) as decimal(10,2)) as proyeccion_mb from t,a;

--modelo para recuperacion 
select name,recovery_model_desc from sys.databases where name=db_name();

--espacio libre en la direccion de los archivos
select distinct vs.volume_mount_point,vs.total_bytes/1048576 as total_mb,vs.available_bytes/1048576 as libre_mb 
from sys.master_files f cross apply sys.dm_os_volume_stats(f.database_id,f.file_id) vs 
where f.database_id=db_id();

--tamano de los ultimos respaldos hechos
select top 10 backup_start_date,type,backup_size/1048576.0 as mb 
from msdb.dbo.backupset 
where database_name=db_name() 
order by backup_start_date desc;

--aplicacion del dimensionamiento propuesto
--32 mbs cubren la proyeccion a 12 meses 
alter database Gimnasio_Reserva modify file (name=Gimnasio_Reserva,size=32MB,filegrowth=16MB);
--16mbs , con limite para que no llene el disco si llegan a faltar respaldos
alter database Gimnasio_Reserva modify file (name=Gimnasio_Reserva_log,size=16MB,filegrowth=8MB,maxsize=256MB);

--verificar
select name,size*8/1024.0 as tamano_mb,
case when is_percent_growth=1 then concat(growth,'%') 
	else concat(growth*8/1024,' MB') 
end as crecimiento,
case when max_size=-1 then 'ilimitado' 
	else concat(cast(max_size*8.0/1024 as int),' MB') 
end as maximo 
from sys.database_files;




