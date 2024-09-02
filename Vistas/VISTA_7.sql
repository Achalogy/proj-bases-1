DROP VIEW VISTA_7;
CREATE VIEW VISTA_7 AS
WITH colabor as (
    SELECT  edificio.id, 
            edificio.nombre, 
            idColaborador, 
            vinculacion
    FROM    meta, colaborador, edificio, piso, cafeteria
    WHERE   colaborador.id = meta.idColaborador AND
            edificio.id = piso.idEdificio AND
            piso.id = cafeteria.idPiso AND
            meta.idcafeteria = cafeteria.id
),
cantidades as (
    SELECT  d1.nombre, 
            COALESCE(numeroPlanta, 0) as numeroPlanta, 
            COALESCE(numeroTemporal, 0) as numeroTemporal, 
            COALESCE(numeroPlanta, 0) + COALESCE(numeroTemporal, 0) as Total
    FROM (
        SELECT nombre, count(idColaborador) as numeroPlanta
        FROM colabor
        WHERE vinculacion = 'PLANTA'
        GROUP BY nombre
    ) d1
    FULL OUTER JOIN (
        SELECT nombre, count(idColaborador) as numeroTemporal
        FROM colabor
        WHERE vinculacion = 'TEMPORAL'
        GROUP BY nombre
    ) d2 ON d1.nombre = d2.nombre
)

SELECT * from cantidades
UNION (
    SELECT  'TOTALES' as nombre, 
            sum(numeroPlanta) as numeroPlanta,
            sum(numeroTemporal) as numeroTemporal,
            sum(total) as total
    from cantidades
);