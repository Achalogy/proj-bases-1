DROP VIEW VISTA_5;
CREATE VIEW VISTA_5 AS
SELECT  nombre, 
        total, 
        sum(valorreal) as ventas, 
        (sum(valorreal) * 100 / total) as porcentajeParticipacion 
FROM colaborador, meta, (
    SELECT sum(valorreal) as total
    FROM meta
) m
WHERE idColaborador = colaborador.id
GROUP BY nombre, total;