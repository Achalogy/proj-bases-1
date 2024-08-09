SELECT cafeteria.nombre, edificio.nombre, piso.numeropiso, colaborador.nombre, colaborador.tipodocumento, colaborador.numerodocumento, meta.fechameta, meta.valormeta, meta.valorreal, ((meta.valormeta - meta.valorreal)/meta.valorreal) * 100 as variacionporcentual
  FROM (cafeteria, meta, colaborador, edificio, piso) 
  WHERE cafeteria.id=meta.idCafeteria 
    AND colaborador.id=meta.idColaborador 
    AND cafeteria.idPiso=piso.id 
    AND piso.idEdificio=edificio.id;