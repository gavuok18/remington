-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 05 (ejercicios 5 y 11) - Clinica San Patras
--   PACIENTE 1:N INGRESO ; MEDICO 1:N INGRESO
-- =====================================================================
DROP DATABASE IF EXISTS caso05_clinica;
CREATE DATABASE caso05_clinica CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso05_clinica;

CREATE TABLE paciente (
  codigo           INT         NOT NULL AUTO_INCREMENT,
  nombre           VARCHAR(50) NOT NULL,
  apellidos        VARCHAR(80) NOT NULL,
  direccion        VARCHAR(120),
  poblacion        VARCHAR(60),
  provincia        VARCHAR(60),
  cod_postal       VARCHAR(10),
  telefono         VARCHAR(20),
  fecha_nacimiento DATE,
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE medico (
  codigo       INT         NOT NULL AUTO_INCREMENT,
  nombre       VARCHAR(50) NOT NULL,
  apellidos    VARCHAR(80) NOT NULL,
  telefono     VARCHAR(20),
  especialidad VARCHAR(60),
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE ingreso (
  cod_ingreso     INT         NOT NULL AUTO_INCREMENT,
  habitacion      VARCHAR(10),
  cama            VARCHAR(10),
  fecha_ingreso   DATE        NOT NULL,
  codigo_paciente INT         NOT NULL,          -- REALIZA 1:N
  codigo_medico   INT         NOT NULL,          -- ATIENDE 1:N
  PRIMARY KEY (cod_ingreso),
  CONSTRAINT fk_ingreso_paciente FOREIGN KEY (codigo_paciente)
    REFERENCES paciente(codigo) ON UPDATE CASCADE,
  CONSTRAINT fk_ingreso_medico   FOREIGN KEY (codigo_medico)
    REFERENCES medico(codigo) ON UPDATE CASCADE
) ENGINE=InnoDB;
