SELECT  cafeteria.nombre, 
        COALESCE(SUM(meta.valorreal), 0) AS ventas
  
FROM cafeteria

LEFT JOIN meta ON cafeteria.id = meta.idcafeteria

GROUP BY  cafeteria.id;
