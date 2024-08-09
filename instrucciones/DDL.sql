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
    on delete cascade 
);

create table cafeteria (
  id          INTEGER AUTO_INCREMENT,
  nombre      VARCHAR(255),
  idPiso      INTEGER,

  primary key (id),
  foreign key (idPiso) references piso (id)
    on delete cascade
);

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