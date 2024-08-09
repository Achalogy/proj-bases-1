# Proyecto Bases

- Miguel Francisco Vargas Contreras
- Nicolas Diaz Granados Cano
- Sara Rodriguez Urueña

## Documentación

Este proyecto fue probado en MariaDB y Oracle Server.

### Creación de tablas

Se crearon dos archivos: `DDL.sql` y `DDL+drop.sql`, ambos destinados a la creación de tablas en la base de datos. La razón para usar dos archivos separados es permitir la limpieza previa de las tablas existentes. Si la base de datos no está vacía, el archivo `DDL+drop.sql` eliminará las tablas existentes antes de crear las nuevas.

El orden utilizado para la creación de las tablas es el siguiente:

1. **Edificio**
2. **Piso**
3. **Cafetería**
4. **Colaborador**
5. **Meta**

Este orden asegura que primero se creen las tablas sin relaciones, facilitando así la creación de las tablas que dependen de ellas. En el archivo `DDL+drop.sql`, las tablas se eliminarán en el orden inverso:

```sql
drop table meta;
drop table colaborador;
drop table cafeteria;
drop table piso;
drop table edificio;
```

#### Edificio

```sql
create table edificio(
  id          INTEGER AUTO_INCREMENT,
  nombre      VARCHAR(255),

  primary key (id)
);
```

#### Piso

```sql
create table piso (
  id          INTEGER AUTO_INCREMENT,
  numeropiso  INTEGER,
  idEdificio  INTEGER,

  primary key (id),
  foreign key (idEdificio) references edificio (id)
    on delete cascade
);
```

#### Cafetería

```sql
create table cafeteria (
  id          INTEGER AUTO_INCREMENT,
  nombre      VARCHAR(255),
  idPiso      INTEGER,

  primary key (id),
  foreign key (idPiso) references piso (id)
    on delete cascade
);
```

#### Colaborador

```sql
create table colaborador (
  id              INTEGER AUTO_INCREMENT,
  nombre          VARCHAR(255),
  tipodocumento   VARCHAR(255),
  numerodocumento INTEGER,
  vinculacion     VARCHAR(255)
		check (vinculacion in ('PLANTA', 'TEMPORAL')),
  comision        INTEGER,

  primary key (id)
);
```

De acuerdo con el enunciado del proyecto, la validación de la vinculación realizará una verificación para asegurar que el dato ingresado sea `'PLANTA'` o `'TEMPORAL'`.

```sql
create table meta (
  id            INTEGER AUTO_INCREMENT,
  fechameta     INTEGER,
  valormeta     INTEGER,
  valorreal     INTEGER,
  idCafeteria   INTEGER,
  idColaborador INTEGER,

  primary key (id),
  foreign key (idCafeteria) references cafeteria (id)
    on delete cascade,
  foreign key (idColaborador) references colaborador (id)
    on delete cascade
);
```

### Creación de relaciones

Se utiliza la estructura `INSERT INTO tabla (nombre_datos...) VALUES (datos...)` porque el `id` se genera automáticamente por la base de datos. Por lo tanto, es necesario especificar los datos y el orden en que se van a insertar.

La inserción de los datos para la tabla `edificio` se realizó manualmente. Posteriormente, se utilizó [ChatGPT](https://chat.openai.com) para generar las inserciones para las tablas `piso`, `cafetería`, `meta` y `colaborador`. Esta última tabla requirió un [script](https://github.com/Achalogy/proj-bases-1/blob/main/utils/main.ts) en `TypeScript` para generar fechas aleatorias.

Estas instrucciones se guardan en el archivo `relationsInsertFile.sql`, que comienza eliminando todos los datos de cada tabla.

### Desarrollo de ejercicios

#### VISTA_1

> Listado de colaboradores, cafeterías y metas. Liste la cafetería, nombre del edificio, número del piso, nombre del colaborador, número y tipo de documento, fecha de meta, valor de las metas de ventas y valor real de ventas, diferencia porcentual entre meta y valor real. Ordene por fecha de meta, nombre de cafetería nombre de colaborador.

Se uso la definición de variación porcentual tomada de internet: _Se calcula restando el valor antiguo del nuevo y luego, se divide el valor obtenido sobre el valor absoluto antiguo y se multiplica por 100._

```sql
((meta.valormeta - meta.valorreal)/meta.valorreal) * 100 as variacionporcentual
```

Ya con esta formula tenemos todos los datos necesarios para la query.

```sql
SELECT  cafeteria.nombre, 
        edificio.nombre, 
        piso.numeropiso, 
        colaborador.nombre, 
        colaborador.tipodocumento, 
        colaborador.numerodocumento, 
        meta.fechameta, 
        meta.valormeta, 
        meta.valorreal, 
        ((meta.valormeta - meta.valorreal)/meta.valorreal) * 100 as variacionporcentual

FROM  cafeteria, 
      meta, 
      colaborador, 
      edificio, 
      piso
      
WHERE cafeteria.id=meta.idCafeteria
  AND colaborador.id=meta.idColaborador
  AND cafeteria.idPiso=piso.id
  AND piso.idEdificio=edificio.id

ORDER BY  meta.fechameta, 
          cafeteria.nombre, 
          colaborador.nombre;
```

#### VISTA_2

> Cuales son las ventas totales de cada cafetería?, liste el nombre de la cafetería, total de ventas. Las cafeterías que no tienen ventas deben aparecer en el listado.

Para cambiar el valor `NULL` de las cafeterías sin ventas a `0`, utilizamos la función `COALESCE(SUM(meta.valormeta), 0)`. Esta función calcula la suma de ventas y reemplaza los valores `NULL` por `0`.

Además, empleamos un `LEFT JOIN` (⋈) para combinar los datos de ventas (de la tabla `meta`) con cada cafetería, uniendo las tablas mediante `cafeteria.id = meta.idcafeteria`.


```sql
SELECT  cafeteria.nombre, 
        COALESCE(SUM(meta.valormeta), 0) AS ventas
  
FROM cafeteria

LEFT JOIN meta ON cafeteria.id = meta.idcafeteria

GROUP BY  cafeteria.id;
``` 

#### VISTA_3

> Cuál es el valor por pagar a cada colaborador en cada mes y año? Liste el nombre del colaborador, el valor a pagar (total de ventas multiplicado por la comisión del colaborador). En una última fila muestre el total general de todos los colaboradores. 

```sql
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
```