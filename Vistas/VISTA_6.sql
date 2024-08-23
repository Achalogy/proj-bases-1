SELECT nombre
FROM (
    SELECT DISTINCT nombre, 
                count(idCafeteria) as trabajaEn,
                ccafeterias
    FROM (
        SELECT COUNT(cafeteria.id) as ccafeterias
        FROM cafeteria
    ) cantcafeterias, (
        SELECT DISTINCT nombre, colaborador.id, idCafeteria
        FROM colaborador, meta
        WHERE meta.idColaborador=colaborador.id
    ) colab
    GROUP BY nombre, ccafeterias
)
WHERE trabajaen=ccafeterias;