-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 16 (ejercicio 22) - Proyectos, colaboradores y pagos
--   CLIENTE 1:N PROYECTO ; PROYECTO N:N COLABORADOR -> PARTICIPA
--   COLABORADOR 1:N PAGO (RECIBE) ; TIPO_PAGO 1:N PAGO
-- =====================================================================
DROP DATABASE IF EXISTS caso16_proyectos;
CREATE DATABASE caso16_proyectos CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso16_proyectos;

CREATE TABLE cliente (
  codigo       INT         NOT NULL AUTO_INCREMENT,
  telefono     VARCHAR(20),
  domicilio    VARCHAR(120),
  razon_social VARCHAR(120) NOT NULL,
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE proyecto (
  codigo         INT           NOT NULL AUTO_INCREMENT,
  descripcion    VARCHAR(200)  NOT NULL,
  cuantia        DECIMAL(12,2),
  fecha_inicio   DATE,
  fecha_fin      DATE,
  codigo_cliente INT           NOT NULL,         -- REALIZA 1:N
  PRIMARY KEY (codigo),
  CONSTRAINT fk_proyecto_cliente FOREIGN KEY (codigo_cliente)
    REFERENCES cliente(codigo) ON UPDATE CASCADE,
  CONSTRAINT ck_proyecto_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
) ENGINE=InnoDB;

CREATE TABLE colaborador (
  nif        VARCHAR(15) NOT NULL,
  nombre     VARCHAR(80) NOT NULL,
  domicilio  VARCHAR(120),
  telefono   VARCHAR(20),
  banco      VARCHAR(60),
  num_cuenta VARCHAR(34),
  PRIMARY KEY (nif)
) ENGINE=InnoDB;

CREATE TABLE participa (                         -- sale de la N:N
  codigo_proyecto INT         NOT NULL,
  nif             VARCHAR(15) NOT NULL,
  PRIMARY KEY (codigo_proyecto, nif),
  CONSTRAINT fk_participa_proyecto    FOREIGN KEY (codigo_proyecto)
    REFERENCES proyecto(codigo) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_participa_colaborador FOREIGN KEY (nif)
    REFERENCES colaborador(nif) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tipo_pago (
  codigo      INT          NOT NULL AUTO_INCREMENT,
  descripcion VARCHAR(100) NOT NULL,
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE pago (
  num_pago         INT           NOT NULL AUTO_INCREMENT,
  concepto         VARCHAR(150),
  cantidad         DECIMAL(10,2) NOT NULL DEFAULT 0,
  fecha_pago       DATE          NOT NULL,
  nif_colaborador  VARCHAR(15)   NOT NULL,       -- RECIBE 1:N
  codigo_tipo_pago INT           NOT NULL,       -- ES_DE_TIPO 1:N
  PRIMARY KEY (num_pago),
  CONSTRAINT fk_pago_colaborador FOREIGN KEY (nif_colaborador)
    REFERENCES colaborador(nif) ON UPDATE CASCADE,
  CONSTRAINT fk_pago_tipo        FOREIGN KEY (codigo_tipo_pago)
    REFERENCES tipo_pago(codigo) ON UPDATE CASCADE
) ENGINE=InnoDB;
