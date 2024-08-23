DROP VIEW VISTA_3;
CREATE VIEW VISTA_3 AS
WITH pagos AS (
    SELECT  nombre,
            anhoMes, 
            sum(valormeta) AS ventas,
            comision,
            ROUND(SUM(valormeta) * ( comision / 100 )) AS pago
    FROM colaborador, (
            SELECT  idcolaborador, 
                    ROUND(fechameta/100) as anhoMes, 
                    valormeta
            FROM meta
    ) m
    WHERE colaborador.id = idcolaborador
    GROUP BY anhoMes, nombre, comision
    ORDER BY nombre, comision
)

SELECT * FROM pagos

UNION ALL

SELECT  nombre, 
        anho_mes, 
        ventas, 
        comision, 
        SUM(pago) as pago 
FROM (
    SELECT  'TOTAL' as nombre, 
            null as anho_mes, 
            null as ventas, 
            null as comision, 
            pago from pagos
);
