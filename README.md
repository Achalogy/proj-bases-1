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
