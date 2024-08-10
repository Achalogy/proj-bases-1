WITH colabCafeterias AS (
  SELECT DISTINCT nombre, 
                  idCafeteria 
  FROM colaborador
  LEFT JOIN meta ON meta.idColaborador=colaborador.id
),
cantCafeterias AS (
  SELECT COUNT(id) as cantidad
  FROM cafeteria
),
filtro AS (
  SELECT nombre, COUNT(idCafeteria) AS cafeteriasColaborador, cantidad
  FROM colabCafeterias, cantCafeterias
  GROUP BY nombre
) 
SELECT nombre as colaboradorEnTodasLasCafeterias
FROM filtro
WHERE cafeteriasColaborador=cantidad;