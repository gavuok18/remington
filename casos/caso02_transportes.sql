-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 02 (ejercicios 2 y 8) - Empresa de transportes
--   CAMION N:N CAMIONERO -> CONDUCE (con fecha en la PK)
--   CAMIONERO 1:N PAQUETE / PROVINCIA 1:N PAQUETE (LLEGA)
-- =====================================================================
DROP DATABASE IF EXISTS caso02_transportes;
CREATE DATABASE caso02_transportes CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso02_transportes;

CREATE TABLE camion (
  matricula VARCHAR(15) NOT NULL,
  modelo    VARCHAR(50),
  tipo      VARCHAR(50),
  potencia  INT,
  PRIMARY KEY (matricula)
) ENGINE=InnoDB;

CREATE TABLE camionero (
  dni       VARCHAR(15)  NOT NULL,
  nombre    VARCHAR(80)  NOT NULL,
  telefono  VARCHAR(20),
  direccion VARCHAR(120),
  salario   DECIMAL(10,2),
  poblacion VARCHAR(60),
  PRIMARY KEY (dni)
) ENGINE=InnoDB;

CREATE TABLE provincia (
  cod_provincia INT         NOT NULL,
  nombre        VARCHAR(60) NOT NULL,
  PRIMARY KEY (cod_provincia)
) ENGINE=InnoDB;

CREATE TABLE paquete (
  cod_paquete      INT          NOT NULL AUTO_INCREMENT,
  descripcion      VARCHAR(150),
  destinatario     VARCHAR(80)  NOT NULL,
  dir_destinatario VARCHAR(120),
  dni_camionero    VARCHAR(15)  NOT NULL,        -- DISTRIBUYE 1:N
  cod_provincia    INT          NOT NULL,        -- LLEGA 1:N
  PRIMARY KEY (cod_paquete),
  CONSTRAINT fk_paquete_camionero FOREIGN KEY (dni_camionero)
    REFERENCES camionero(dni) ON UPDATE CASCADE,
  CONSTRAINT fk_paquete_provincia FOREIGN KEY (cod_provincia)
    REFERENCES provincia(cod_provincia) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE conduce (                           -- sale de la N:N
  dni       VARCHAR(15) NOT NULL,
  matricula VARCHAR(15) NOT NULL,
  fecha     DATE        NOT NULL,
  PRIMARY KEY (dni, matricula, fecha),
  CONSTRAINT fk_conduce_camionero FOREIGN KEY (dni)
    REFERENCES camionero(dni) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_conduce_camion FOREIGN KEY (matricula)
    REFERENCES camion(matricula) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
