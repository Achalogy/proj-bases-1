DROP VIEW VISTA_4;
CREATE VIEW VISTA_4 AS
SELECT  anhoMes, 
        sum(valorreal) as ventas, 
        sum(valormeta) as metas,
        sum(valormeta) - sum(valorreal) as diferencia
FROM (
            SELECT  ROUND(fechameta/100) as anhoMes, 
                    valorreal,
                    valormeta
            FROM meta
    ) m
GROUP BY anhoMes
ORDER BY anhoMes;