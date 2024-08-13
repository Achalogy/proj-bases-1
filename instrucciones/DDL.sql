-- TODO revisar las claves U
create table edificio(
  id          INTEGER AUTO_INCREMENT,
  nombre      VARCHAR(255),

  primary key (id)
);

-- TODO revisar si usar el on delete
create table piso (
  id          INTEGER AUTO_INCREMENT,
  numeropiso  INTEGER,
  idEdificio  INTEGER,

  primary key (id),
  foreign key (idEdificio) references edificio (id)
    on delete set null 
);

create table cafeteria (
  id          INTEGER AUTO_INCREMENT,
  nombre      VARCHAR(255),
  idPiso      INTEGER,

  primary key (id),
  foreign key (idPiso) references piso (id)
    on delete set null
);

create table colaborador (
  id              INTEGER AUTO_INCREMENT,
  nombre          VARCHAR(255),
  tipodocumento   VARCHAR(255),
  numerodocumento INTEGER,
  vinculacion     VARCHAR(255) 
		check (vinculacion in ('PLANTA', 'TEMPORAL')),
  comision        INTEGER DEFAULT 10
    check (comision >= 0 AND comision <= 100),

  primary key (id)
);

create table meta (
  id            INTEGER AUTO_INCREMENT,
  fechameta     INTEGER,
  valormeta     INTEGER DEFAULT 0,
  valorreal     INTEGER DEFAULT 0,
  idCafeteria   INTEGER,
  idColaborador INTEGER,

  primary key (id),
  foreign key (idCafeteria) references cafeteria (id)
    on delete set null,
  foreign key (idColaborador) references colaborador (id)
    on delete set null
);