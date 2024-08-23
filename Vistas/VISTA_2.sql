SELECT  cafeteria.id, cafeteria.nombre, 
        COALESCE(SUM(meta.valormeta), 0) AS ventas
FROM cafeteria, meta
WHERE cafeteria.id = meta.idcafeteria
GROUP BY cafeteria.id, cafeteria.nombre
ORDER BY cafeteria.id;
