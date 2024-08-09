WITH pagos AS (
  SELECT colaborador.nombre, ROUND(fechameta/100) as anho_mes,
        COALESCE(SUM(meta.valormeta),0) AS ventas,
        colaborador.comision,
        COALESCE(ROUND(SUM(meta.valormeta) * ( colaborador.comision / 100 )), 0) AS pago
  FROM meta

  LEFT JOIN colaborador ON colaborador.id = meta.idColaborador

  GROUP BY anho_mes

  ORDER BY colaborador.nombre
),

total AS (
  SELECT "TOTAL" as nombre, null as anho_mes, null as ventas, null as comision, pago from pagos
)

SELECT * FROM pagos

UNION ALL

SELECT nombre, anho_mes, ventas, comision, SUM(pago) as pago from total;