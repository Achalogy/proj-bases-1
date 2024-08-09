# Proyecto Bases

- Miguel Francisco Vargas Contreras
- Nicolas
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

TODO: Ordenar 

> Listado de colaboradores, cafeterías y metas. Liste la cafetería, nombre del edificio, número del piso, nombre del colaborador, número y tipo de documento, fecha de meta, valor de las metas de ventas y valor real de ventas, diferencia porcentual entre meta y valor real. Ordene por fecha de meta, nombre de cafetería nombre de colaborador.

Se uso la definición de variación porcentual tomada de internet: _Se calcula restando el valor antiguo del nuevo y luego, se divide el valor obtenido sobre el valor absoluto antiguo y se multiplica por 100._

```sql
((meta.valormeta - meta.valorreal)/meta.valorreal) * 100 as variacionporcentual
```

Ya con esta formula tenemos todos los datos necesarios para la query.

```sql
SELECT cafeteria.nombre, edificio.nombre, piso.numeropiso, colaborador.nombre, colaborador.tipodocumento, colaborador.numerodocumento, meta.fechameta, meta.valormeta, meta.valorreal, ((meta.valormeta - meta.valorreal)/meta.valorreal) * 100 as variacionporcentual
  FROM (cafeteria, meta, colaborador, edificio, piso)
  WHERE cafeteria.id=meta.idCafeteria
    AND colaborador.id=meta.idColaborador
    AND cafeteria.idPiso=piso.id
    AND piso.idEdificio=edificio.id;
```

Resultado:

```
+---------------+------------------------------------+------------+-------------------+---------------+-----------------+-----------+-----------+-----------+------------+
| nombre        | nombre                             | numeropiso | nombre            | tipodocumento | numerodocumento | fechameta | valormeta | valorreal | porcentual |
+---------------+------------------------------------+------------+-------------------+---------------+-----------------+-----------+-----------+-----------+------------+
| Cafetería 1   | Ed. Fernando Baron                 |          1 | Ana Gómez         | CC            |        12345678 |  20230626 |     10000 |      9500 |     5.2632 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20210421 |     16000 |     15500 |     3.2258 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20230407 |     19500 |     19000 |     2.6316 |
| Cafetería 1   | Ed. Fernando Baron                 |          1 | Ana Gómez         | CC            |        12345678 |  20230309 |     12000 |     11500 |     4.3478 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20220417 |     20000 |     19500 |     2.5641 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20210411 |     30000 |     29500 |     1.6949 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20230620 |     40000 |     39500 |     1.2658 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20210220 |     50000 |     49500 |     1.0101 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20220617 |     60000 |     59500 |     0.8403 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20210512 |     70000 |     69500 |     0.7194 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20220519 |     80000 |     79500 |     0.6289 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20210612 |     90000 |     89500 |     0.5587 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20230227 |    100000 |     99500 |     0.5025 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20220309 |    110000 |    109500 |     0.4566 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20230405 |    120000 |    119500 |     0.4184 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20210212 |    130000 |    129500 |     0.3861 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20220210 |    140000 |    139500 |     0.3584 |
| Cafetería 11  | Hospital Universitario San Ignacio |          1 | Ana Gómez         | CC            |        12345678 |  20220114 |    150000 |    149500 |     0.3344 |
| Cafetería 2   | Ed. Gabriel Giraldo                |          1 | Luis Martínez     | CC            |        23456789 |  20220626 |     12000 |     11500 |     4.3478 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20230408 |     13500 |     13000 |     3.8462 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20230124 |     20500 |     20000 |     2.5000 |
| Cafetería 2   | Ed. Gabriel Giraldo                |          1 | Luis Martínez     | CC            |        23456789 |  20220222 |     13000 |     12500 |     4.0000 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20210318 |     21000 |     20500 |     2.4390 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20220226 |     31000 |     30500 |     1.6393 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20210607 |     41000 |     40500 |     1.2346 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20210425 |     51000 |     50500 |     0.9901 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20230319 |     61000 |     60500 |     0.8264 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20210323 |     71000 |     70500 |     0.7092 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20210507 |     81000 |     80500 |     0.6211 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20230110 |     91000 |     90500 |     0.5525 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20230621 |    101000 |    100500 |     0.4975 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20220623 |    111000 |    110500 |     0.4525 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20220115 |    121000 |    120500 |     0.4149 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20230222 |    131000 |    130500 |     0.3831 |
| Cafetería 12  | Hospital Universitario San Ignacio |          2 | Luis Martínez     | CC            |        23456789 |  20230317 |    141000 |    140500 |     0.3559 |
| Cafetería 3   | Ed. Arango Puerta                  |          1 | María Fernández   | CC            |        34567890 |  20210321 |      9000 |      8800 |     2.2727 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20210404 |     12500 |     12000 |     4.1667 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20230126 |     21500 |     21000 |     2.3810 |
| Cafetería 3   | Ed. Arango Puerta                  |          1 | María Fernández   | CC            |        34567890 |  20220206 |     11000 |     10500 |     4.7619 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20230123 |     22000 |     21500 |     2.3256 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20230410 |     32000 |     31500 |     1.5873 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20210612 |     42000 |     41500 |     1.2048 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20220603 |     52000 |     51500 |     0.9709 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20220512 |     62000 |     61500 |     0.8130 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20210610 |     72000 |     71500 |     0.6993 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20220422 |     82000 |     81500 |     0.6135 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20230227 |     92000 |     91500 |     0.5464 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20230321 |    102000 |    101500 |     0.4926 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20220306 |    112000 |    111500 |     0.4484 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20210606 |    122000 |    121500 |     0.4115 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20230113 |    132000 |    131500 |     0.3802 |
| Cafetería 13  | Ed. Pablo VI                       |          3 | María Fernández   | CC            |        34567890 |  20230124 |    142000 |    141500 |     0.3534 |
| Cafetería 4   | Ed. Atico                          |          1 | Carlos López      | CC            |        45678901 |  20210422 |     11000 |     10500 |     4.7619 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20220605 |     11000 |     10500 |     4.7619 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20220111 |     22500 |     22000 |     2.2727 |
| Cafetería 4   | Ed. Atico                          |          1 | Carlos López      | CC            |        45678901 |  20230313 |     14000 |     13000 |     7.6923 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20220518 |     23000 |     22500 |     2.2222 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20220423 |     33000 |     32500 |     1.5385 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20230525 |     43000 |     42500 |     1.1765 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20220517 |     53000 |     52500 |     0.9524 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20210513 |     63000 |     62500 |     0.8000 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20220523 |     73000 |     72500 |     0.6897 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20230325 |     83000 |     82500 |     0.6061 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20220210 |     93000 |     92500 |     0.5405 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20230119 |    103000 |    102500 |     0.4878 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20210122 |    113000 |    112500 |     0.4444 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20210617 |    123000 |    122500 |     0.4082 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20230411 |    133000 |    132500 |     0.3774 |
| Cafetería 14  | Ed. Felix Restrepo                 |          6 | Carlos López      | CC            |        45678901 |  20220513 |    143000 |    142500 |     0.3509 |
| Cafetería 5   | Ed. Julio Carrizosa                |          2 | Elena Rodríguez   | CC            |        56789012 |  20220416 |     13000 |     12000 |     8.3333 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20220416 |     14500 |     14000 |     3.5714 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20210416 |     23500 |     23000 |     2.1739 |
| Cafetería 5   | Ed. Julio Carrizosa                |          2 | Elena Rodríguez   | CC            |        56789012 |  20230425 |     12500 |     12000 |     4.1667 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20210405 |     24000 |     23500 |     2.1277 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20220512 |     34000 |     33500 |     1.4925 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20210523 |     44000 |     43500 |     1.1494 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20210612 |     54000 |     53500 |     0.9346 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20210624 |     64000 |     63500 |     0.7874 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20210227 |     74000 |     73500 |     0.6803 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20220614 |     84000 |     83500 |     0.5988 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20220323 |     94000 |     93500 |     0.5348 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20220620 |    104000 |    103500 |     0.4831 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20230220 |    114000 |    113500 |     0.4405 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20210410 |    124000 |    123500 |     0.4049 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20210303 |    134000 |    133500 |     0.3745 |
| Cafetería 15  | Ed. Jose Rafael Arboleda           |          3 | Elena Rodríguez   | CC            |        56789012 |  20230605 |    144000 |    143500 |     0.3484 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20210517 |     11500 |     11000 |     4.5455 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20220403 |     15500 |     15000 |     3.3333 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20220426 |     15000 |     14500 |     3.4483 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20220204 |     25000 |     24500 |     2.0408 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20220317 |     35000 |     34500 |     1.4493 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20220616 |     45000 |     44500 |     1.1236 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20220414 |     55000 |     54500 |     0.9174 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20210404 |     65000 |     64500 |     0.7752 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20220624 |     75000 |     74500 |     0.6711 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20230116 |     85000 |     84500 |     0.5917 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20220401 |     95000 |     94500 |     0.5291 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20230622 |    105000 |    104500 |     0.4785 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20220202 |    115000 |    114500 |     0.4367 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20230509 |    125000 |    124500 |     0.4016 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20230406 |    135000 |    134500 |     0.3717 |
| Cafetería 6   | Ed. Jose Gabriel Maldonado         |          1 | Jorge Pérez       | CC            |        67890123 |  20210311 |    145000 |    144500 |     0.3460 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20230608 |     14000 |     13500 |     3.7037 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20230603 |     17000 |     16500 |     3.0303 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20220220 |     16000 |     15500 |     3.2258 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20210508 |     26000 |     25500 |     1.9608 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20210522 |     36000 |     35500 |     1.4085 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20220417 |     46000 |     45500 |     1.0989 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20210324 |     56000 |     55500 |     0.9009 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20210407 |     66000 |     65500 |     0.7634 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20220418 |     76000 |     75500 |     0.6623 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20230116 |     86000 |     85500 |     0.5848 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20220303 |     96000 |     95500 |     0.5236 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20230407 |    106000 |    105500 |     0.4739 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20210311 |    116000 |    115500 |     0.4329 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20220413 |    126000 |    125500 |     0.3984 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20230401 |    136000 |    135500 |     0.3690 |
| Cafetería 7   | Ed. Jose Gabriel Maldonado         |          2 | Laura Díaz        | CC            |        78901234 |  20220503 |    146000 |    145500 |     0.3436 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20230401 |     12500 |     12000 |     4.1667 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20230526 |     16000 |     15500 |     3.2258 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20230405 |     17000 |     16500 |     3.0303 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20220308 |     27000 |     26500 |     1.8868 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20210403 |     37000 |     36500 |     1.3699 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20210302 |     47000 |     46500 |     1.0753 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20230303 |     57000 |     56500 |     0.8850 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20230426 |     67000 |     66500 |     0.7519 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20230314 |     77000 |     76500 |     0.6536 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20210206 |     87000 |     86500 |     0.5780 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20220402 |     97000 |     96500 |     0.5181 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20230226 |    107000 |    106500 |     0.4695 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20220304 |    117000 |    116500 |     0.4292 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20220410 |    127000 |    126500 |     0.3953 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20230617 |    137000 |    136500 |     0.3663 |
| Cafetería 8   | Ed. Jorge Hoyoso Vasques           |          1 | Fernando Torres   | CC            |        89012345 |  20220617 |    147000 |    146500 |     0.3413 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20220513 |     15000 |     14500 |     3.4483 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20210301 |     17500 |     17000 |     2.9412 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20220102 |     18000 |     17500 |     2.8571 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20210526 |     28000 |     27500 |     1.8182 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20220102 |     38000 |     37500 |     1.3333 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20220505 |     48000 |     47500 |     1.0526 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20220613 |     58000 |     57500 |     0.8696 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20210313 |     68000 |     67500 |     0.7407 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20210107 |     78000 |     77500 |     0.6452 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20230110 |     88000 |     87500 |     0.5714 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20220621 |     98000 |     97500 |     0.5128 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20230614 |    108000 |    107500 |     0.4651 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20220301 |    118000 |    117500 |     0.4255 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20210427 |    128000 |    127500 |     0.3922 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20230607 |    138000 |    137500 |     0.3636 |
| Cafetería 9   | Ed. Emilio Arangom                 |          2 | Isabel Morales    | CC            |        90123456 |  20230404 |    148000 |    147500 |     0.3390 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20230407 |     10500 |     10000 |     5.0000 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20210102 |     18500 |     18000 |     2.7778 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20210302 |     19000 |     18500 |     2.7027 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20220512 |     29000 |     28500 |     1.7544 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20210108 |     39000 |     38500 |     1.2987 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20210123 |     49000 |     48500 |     1.0309 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20220604 |     59000 |     58500 |     0.8547 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20230414 |     69000 |     68500 |     0.7299 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20210610 |     79000 |     78500 |     0.6369 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20220111 |     89000 |     88500 |     0.5650 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20210109 |     99000 |     98500 |     0.5076 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20220303 |    109000 |    108500 |     0.4608 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20220524 |    119000 |    118500 |     0.4219 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20220416 |    129000 |    128500 |     0.3891 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20210217 |    139000 |    138500 |     0.3610 |
| Cafetería 10  | Facultad de Artes                  |          2 | Roberto García    | CC            |        12345679 |  20210511 |    149000 |    148500 |     0.3367 |
+---------------+------------------------------------+------------+-------------------+---------------+-----------------+-----------+-----------+-----------+------------+
```
