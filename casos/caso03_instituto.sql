-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 03 (ejercicios 3 y 9) - Instituto: profesores, modulos y cursos
--   PROFESOR 1:N MODULO / CURSO 1:N ALUMNO
--   ALUMNO N:N MODULO -> MATRICULA        DELEGADO 1:1 CURSO-ALUMNO
-- =====================================================================
DROP DATABASE IF EXISTS caso03_instituto;
CREATE DATABASE caso03_instituto CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso03_instituto;

CREATE TABLE profesor (
  dni       VARCHAR(15) NOT NULL,
  nombre    VARCHAR(80) NOT NULL,
  direccion VARCHAR(120),
  telefono  VARCHAR(20),
  PRIMARY KEY (dni)
) ENGINE=InnoDB;

CREATE TABLE modulo (
  codigo       INT         NOT NULL AUTO_INCREMENT,
  nombre       VARCHAR(80) NOT NULL,
  dni_profesor VARCHAR(15),                      -- IMPARTE 1:N
  PRIMARY KEY (codigo),
  CONSTRAINT fk_modulo_profesor FOREIGN KEY (dni_profesor)
    REFERENCES profesor(dni) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE curso (
  codigo INT         NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(80) NOT NULL,
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE alumno (
  num_expediente   INT         NOT NULL AUTO_INCREMENT,
  nombre           VARCHAR(50) NOT NULL,
  apellidos        VARCHAR(80) NOT NULL,
  fecha_nacimiento DATE,
  codigo_curso     INT,                          -- PERTENECE 1:N
  PRIMARY KEY (num_expediente),
  CONSTRAINT fk_alumno_curso FOREIGN KEY (codigo_curso)
    REFERENCES curso(codigo) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE delegado (                          -- 1:1 -> PK + UNIQUE
  codigo_curso   INT NOT NULL,
  num_expediente INT NOT NULL,
  PRIMARY KEY (codigo_curso),
  UNIQUE KEY uq_delegado_alumno (num_expediente),
  CONSTRAINT fk_delegado_curso  FOREIGN KEY (codigo_curso)
    REFERENCES curso(codigo) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_delegado_alumno FOREIGN KEY (num_expediente)
    REFERENCES alumno(num_expediente) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE matricula (                         -- sale de la N:N
  num_expediente INT NOT NULL,
  codigo_modulo  INT NOT NULL,
  PRIMARY KEY (num_expediente, codigo_modulo),
  CONSTRAINT fk_matricula_alumno FOREIGN KEY (num_expediente)
    REFERENCES alumno(num_expediente) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_matricula_modulo FOREIGN KEY (codigo_modulo)
    REFERENCES modulo(codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
