use Gimnasio_Reserva
go


--se crearon tres indices nonclustered utilizando include para evitar escaneos completos 
--en las consultas mas utilizadas 


--1 indice para optimizar análisis de ingresos y los pagos por socio y fecha y su consulta
create nonclustered index IX_Pago_Socio_Fecha
on dbo.Pago (id_socio, fecha_pago)
include (monto, forma_pago, razon);

select 
    s.id_socio,
    s.dui,
    concat(s.nombre, ' ', s.apellido) as nombre_socio,
    count(p.id_pago) as cantidad_pagos,
    sum(p.monto) as total_invertido,
    dense_rank() over (order by sum(p.monto) desc) as ranking_cliente,
    cast(
        (sum(p.monto) * 100.0) / sum(sum(p.monto)) over () 
        as decimal(5,2)
    ) as porcentaje_ingresos_totales
from dbo.socio s
inner join dbo.pago p on s.id_socio = p.id_socio
group by s.id_socio, s.dui, s.nombre, s.apellido
order by ranking_cliente asc;

-- 2. indice para optimizar el conteo y filtrado de reservas por programación y estado
create nonclustered index IX_Reserva_Programacion_Estado
on dbo.Reserva (id_programacion, estado_reserva)
include (id_socio, fecha_reserva);

select 
    p.id_pago,
    p.fecha_pago,
    concat(s.nombre, ' ', s.apellido) as socio,
    p.razon as concepto,
    p.forma_pago,
    p.monto as monto_actual,
    lag(p.monto, 1, 0.00) over (order by p.fecha_pago asc, p.id_pago asc) as monto_pago_anterior,
    p.monto - lag(p.monto, 1, 0.00) over (order by p.fecha_pago asc, p.id_pago asc) as diferencia_vs_anterior,
    sum(p.monto) over (
        order by p.fecha_pago asc, p.id_pago asc 
        rows between unbounded preceding and current row
    ) as ingreso_acumulado_historico
from dbo.pago p
inner join dbo.socio s on p.id_socio = s.id_socio
order by p.fecha_pago asc, p.id_pago asc;
go

-- 3. indice para optimizar el cruce de programación de clases por entrenador, clase y fecha
create nonclustered index IX_Programacion_Clase_Entrenador_Fecha
on dbo.Programacion_clase (id_clase, id_entrenador, fecha)
include (hora_inicio, hora_fin, cupos_disponibles);

with resumen_clases as (
    select 
        c.nombre_clase as disciplina,
        concat(e.nombre, ' ', e.apellido) as entrenador,
        count(r.id_reserva) as reservas_confirmadas,
        max(c.capacidad) as capacidad_sala
    from dbo.programacion_clase pc
    inner join dbo.clases c on pc.id_clase = c.id_clase
    inner join dbo.entrenador e on pc.id_entrenador = e.id_entrenador
    left join dbo.reserva r 
        on pc.id_programacion = r.id_programacion 
        and r.estado_reserva = 'confirmada'
    group by c.nombre_clase, e.nombre, e.apellido
)
select 
    disciplina,
    entrenador,
    reservas_confirmadas,
    capacidad_sala,
    cast(
        avg(cast(reservas_confirmadas as decimal(10,2))) over (partition by disciplina) 
        as decimal(5,2)
    ) as promedio_reservas_demanda,
    row_number() over (
        partition by disciplina 
        order by reservas_confirmadas desc
    ) as puesto_en_demanda
from resumen_clases
order by disciplina asc, puesto_en_demanda asc;
