-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 12 (ejercicio 18) - Organizacion interna de una empresa
--   CENTRO_TRABAJO 1:N DEPARTAMENTO (UBICADO)
--   DEPARTAMENTO 1:N EMPLEADO (ASIGNADO) ; EMPLEADO 1:N HIJO
--   EMPLEADO 1:N CENTRO_TRABAJO (DIRIGE) -> tabla DIRIGE
--   EMPLEADO N:N HABILIDAD -> POSEE
-- =====================================================================
DROP DATABASE IF EXISTS caso12_empresa;
CREATE DATABASE caso12_empresa CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso12_empresa;

CREATE TABLE centro_trabajo (
  cod_centro INT         NOT NULL AUTO_INCREMENT,
  nombre     VARCHAR(80) NOT NULL,
  poblacion  VARCHAR(60),
  direccion  VARCHAR(120),
  PRIMARY KEY (cod_centro)
) ENGINE=InnoDB;

CREATE TABLE departamento (
  codigo             INT           NOT NULL AUTO_INCREMENT,
  nombre             VARCHAR(80)   NOT NULL,
  presupuesto_anual  DECIMAL(12,2),
  cod_centro         INT,                        -- UBICADO 1:N
  PRIMARY KEY (codigo),
  CONSTRAINT fk_departamento_centro FOREIGN KEY (cod_centro)
    REFERENCES centro_trabajo(cod_centro) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE empleado (
  nif                 VARCHAR(15) NOT NULL,
  nombre              VARCHAR(80) NOT NULL,
  telefono            VARCHAR(20),
  fecha_alta          DATE,
  salario             DECIMAL(10,2),
  num_hijos           INT         NOT NULL DEFAULT 0,
  codigo_departamento INT,                       -- ASIGNADO 1:N
  PRIMARY KEY (nif),
  CONSTRAINT fk_empleado_departamento FOREIGN KEY (codigo_departamento)
    REFERENCES departamento(codigo) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE dirige (                            -- 1:N EMPLEADO-CENTRO
  cod_centro INT         NOT NULL,
  nif        VARCHAR(15) NOT NULL,
  PRIMARY KEY (cod_centro),
  CONSTRAINT fk_dirige_centro   FOREIGN KEY (cod_centro)
    REFERENCES centro_trabajo(cod_centro) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_dirige_empleado FOREIGN KEY (nif)
    REFERENCES empleado(nif) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE hijo (
  codigo           INT         NOT NULL AUTO_INCREMENT,
  nombre           VARCHAR(80) NOT NULL,
  fecha_nacimiento DATE,
  nif_empleado     VARCHAR(15) NOT NULL,         -- TIENE 1:N
  PRIMARY KEY (codigo),
  CONSTRAINT fk_hijo_empleado FOREIGN KEY (nif_empleado)
    REFERENCES empleado(nif) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE habilidad (
  codigo      INT          NOT NULL AUTO_INCREMENT,
  descripcion VARCHAR(150) NOT NULL,
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE posee (                             -- sale de la N:N
  nif              VARCHAR(15) NOT NULL,
  codigo_habilidad INT         NOT NULL,
  PRIMARY KEY (nif, codigo_habilidad),
  CONSTRAINT fk_posee_empleado  FOREIGN KEY (nif)
    REFERENCES empleado(nif) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_posee_habilidad FOREIGN KEY (codigo_habilidad)
    REFERENCES habilidad(codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
