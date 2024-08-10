WITH pagos AS (
  SELECT  ROUND(fechameta/100) AS anho_mes,
          COALESCE(SUM(meta.valormeta),0) AS metas,
          COALESCE(SUM(meta.valorreal),0) AS reales

  FROM meta

  GROUP BY anho_mes

  ORDER BY anho_mes
) 
SELECT *, (metas - reales) AS diferencia 
FROM pagos;