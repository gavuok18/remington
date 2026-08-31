-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 08 (ejercicio 14) - Biblioteca del centro
--   AUTOR N:N LIBRO -> ESCRIBE
--   LIBRO 1:N EJEMPLAR (entidad debil: PK compuesta)
--   USUARIO N:N EJEMPLAR -> PRESTAMO
-- =====================================================================
DROP DATABASE IF EXISTS caso08_biblioteca;
CREATE DATABASE caso08_biblioteca CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso08_biblioteca;

CREATE TABLE autor (
  cod_autor INT         NOT NULL AUTO_INCREMENT,
  nombre    VARCHAR(80) NOT NULL,
  PRIMARY KEY (cod_autor)
) ENGINE=InnoDB;

CREATE TABLE libro (
  codigo      INT          NOT NULL AUTO_INCREMENT,
  titulo      VARCHAR(150) NOT NULL,
  isbn        VARCHAR(20),
  editorial   VARCHAR(80),
  num_paginas INT,
  PRIMARY KEY (codigo),
  UNIQUE KEY uq_libro_isbn (isbn)
) ENGINE=InnoDB;

CREATE TABLE ejemplar (                          -- entidad debil de LIBRO
  codigo_libro INT         NOT NULL,
  codigo       INT         NOT NULL,
  localizacion VARCHAR(80),
  PRIMARY KEY (codigo_libro, codigo),
  CONSTRAINT fk_ejemplar_libro FOREIGN KEY (codigo_libro)
    REFERENCES libro(codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE usuario (
  codigo    INT         NOT NULL AUTO_INCREMENT,
  nombre    VARCHAR(80) NOT NULL,
  direccion VARCHAR(120),
  telefono  VARCHAR(20),
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE escribe (                           -- sale de la N:N
  cod_autor    INT NOT NULL,
  codigo_libro INT NOT NULL,
  PRIMARY KEY (cod_autor, codigo_libro),
  CONSTRAINT fk_escribe_autor FOREIGN KEY (cod_autor)
    REFERENCES autor(cod_autor) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_escribe_libro FOREIGN KEY (codigo_libro)
    REFERENCES libro(codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE prestamo (                          -- sale de la N:N
  codigo_usuario   INT  NOT NULL,
  codigo_libro     INT  NOT NULL,
  codigo_ejemplar  INT  NOT NULL,
  fecha_prestamo   DATE NOT NULL,
  fecha_devolucion DATE NULL,
  PRIMARY KEY (codigo_usuario, codigo_libro, codigo_ejemplar, fecha_prestamo),
  CONSTRAINT fk_prestamo_usuario  FOREIGN KEY (codigo_usuario)
    REFERENCES usuario(codigo) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_prestamo_ejemplar FOREIGN KEY (codigo_libro, codigo_ejemplar)
    REFERENCES ejemplar(codigo_libro, codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
