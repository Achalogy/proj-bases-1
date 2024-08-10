WITH trabajadoresEdifio as (
  SELECT DISTINCT colaborador.id as colabId, meta.idCafeteria, colaborador.vinculacion, edificio.nombre, edificio.id as edificioId
  FROM  meta, 
        colaborador,
        cafeteria,
        piso,
        edificio
  WHERE meta.idColaborador=colaborador.id
        AND meta.idCafeteria = cafeteria.id
        AND cafeteria.idPiso = piso.id
        AND piso.idEdificio = edificio.id
),
trabajadoresPlanta AS (
  SELECT  nombre, 
          COUNT(vinculacion) as cantidadPlanta,
          edificioId
  FROM trabajadoresEdifio
  WHERE vinculacion="PLANTA"
  GROUP BY nombre
),
trabajadoresTemporales AS (
  SELECT  nombre, 
          COUNT(vinculacion) as cantidadTemporal,
          edificioId
  FROM trabajadoresEdifio
  WHERE vinculacion="TEMPORAL"
  GROUP BY nombre
) 
SELECT  trabajadoresPlanta.nombre, 
        cantidadPlanta, 
        cantidadTemporal, 
        cantidadPlanta + cantidadTemporal AS total
FROM  trabajadoresPlanta,
      trabajadoresTemporales
WHERE trabajadoresPlanta.edificioId=trabajadoresTemporales.edificioId;