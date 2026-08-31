-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 10 (ejercicio 16) - Liga de futbol profesional
--   PRESIDENTE 1:1 EQUIPO ; EQUIPO 1:N JUGADOR
--   EQUIPO 1:N PARTIDO dos veces (LOCAL y VISITANTE)
--   PARTIDO 1:N GOL ; JUGADOR 1:N GOL (MARCA)
-- =====================================================================
DROP DATABASE IF EXISTS caso10_liga_futbol;
CREATE DATABASE caso10_liga_futbol CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso10_liga_futbol;

CREATE TABLE equipo (
  cod_equipo     INT         NOT NULL AUTO_INCREMENT,
  nombre         VARCHAR(80) NOT NULL,
  estadio        VARCHAR(80),
  aforo          INT,
  anio_fundacion YEAR,
  ciudad         VARCHAR(60),
  PRIMARY KEY (cod_equipo)
) ENGINE=InnoDB;

CREATE TABLE presidente (
  dni              VARCHAR(15) NOT NULL,
  nombre           VARCHAR(50) NOT NULL,
  apellidos        VARCHAR(80) NOT NULL,
  fecha_nacimiento DATE,
  anio_eleccion    YEAR,
  cod_equipo       INT         NOT NULL,         -- PRESIDE 1:1
  PRIMARY KEY (dni),
  UNIQUE KEY uq_presidente_equipo (cod_equipo),  -- garantiza el 1:1
  CONSTRAINT fk_presidente_equipo FOREIGN KEY (cod_equipo)
    REFERENCES equipo(cod_equipo) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE jugador (
  cod_jugador      INT         NOT NULL AUTO_INCREMENT,
  nombre           VARCHAR(80) NOT NULL,
  fecha_nacimiento DATE,
  posicion         VARCHAR(30),
  cod_equipo       INT,                          -- PERTENECE 1:N
  PRIMARY KEY (cod_jugador),
  CONSTRAINT fk_jugador_equipo FOREIGN KEY (cod_equipo)
    REFERENCES equipo(cod_equipo) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE partido (
  cod_partido          INT  NOT NULL AUTO_INCREMENT,
  fecha                DATE NOT NULL,
  goles_local          INT  NOT NULL DEFAULT 0,
  goles_visitante      INT  NOT NULL DEFAULT 0,
  cod_equipo_local     INT  NOT NULL,            -- LOCAL 1:N
  cod_equipo_visitante INT  NOT NULL,            -- VISITANTE 1:N
  PRIMARY KEY (cod_partido),
  CONSTRAINT fk_partido_local     FOREIGN KEY (cod_equipo_local)
    REFERENCES equipo(cod_equipo) ON UPDATE CASCADE,
  CONSTRAINT fk_partido_visitante FOREIGN KEY (cod_equipo_visitante)
    REFERENCES equipo(cod_equipo) ON UPDATE CASCADE,
  CONSTRAINT ck_partido_equipos CHECK (cod_equipo_local <> cod_equipo_visitante)
) ENGINE=InnoDB;

CREATE TABLE gol (
  cod_gol     INT          NOT NULL AUTO_INCREMENT,  -- PK propia
  minuto      INT          NOT NULL,
  descripcion VARCHAR(150),
  cod_partido INT          NOT NULL,             -- TIENE 1:N
  cod_jugador INT          NOT NULL,             -- MARCA 1:N
  PRIMARY KEY (cod_gol),
  CONSTRAINT fk_gol_partido FOREIGN KEY (cod_partido)
    REFERENCES partido(cod_partido) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_gol_jugador FOREIGN KEY (cod_jugador)
    REFERENCES jugador(cod_jugador) ON UPDATE CASCADE
) ENGINE=InnoDB;
