WITH ventasColaborador AS (
  SELECT colaborador.nombre,
        COALESCE(SUM(meta.valorreal),0) AS ventas,
        COALESCE(COUNT(meta.valorreal),0) AS cantidadVentas
  FROM meta

  LEFT JOIN colaborador ON colaborador.id = meta.idColaborador

  GROUP BY colaborador.nombre

  ORDER BY colaborador.nombre
),
total as (
  SELECT SUM(meta.valorreal) as total 
  FROM meta
) 
SELECT  nombre, 
        cantidadVentas, 
        ventas, 
        (ventas * 100 / total) as porcentajeParticipacion 
FROM ventasColaborador, total;