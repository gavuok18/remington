-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 04 (ejercicios 4 y 10) - Venta de automoviles
--   CLIENTE 1:N COCHE 1:N REVISION  (todo con FK, no hay N:N)
-- =====================================================================
DROP DATABASE IF EXISTS caso04_automoviles;
CREATE DATABASE caso04_automoviles CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso04_automoviles;

CREATE TABLE cliente (
  cod_cliente INT         NOT NULL AUTO_INCREMENT,
  nif         VARCHAR(15) NOT NULL,
  nombre      VARCHAR(80) NOT NULL,
  direccion   VARCHAR(120),
  ciudad      VARCHAR(60),
  telefono    VARCHAR(20),
  PRIMARY KEY (cod_cliente),
  UNIQUE KEY uq_cliente_nif (nif)
) ENGINE=InnoDB;

CREATE TABLE coche (
  matricula    VARCHAR(15)   NOT NULL,
  marca        VARCHAR(50),
  modelo       VARCHAR(50),
  color        VARCHAR(30),
  precio_venta DECIMAL(10,2),
  cod_cliente  INT,                              -- COMPRA 1:N
  PRIMARY KEY (matricula),
  CONSTRAINT fk_coche_cliente FOREIGN KEY (cod_cliente)
    REFERENCES cliente(cod_cliente) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE revision (
  cod_revision  INT         NOT NULL AUTO_INCREMENT,
  cambio_filtro BOOLEAN     NOT NULL DEFAULT FALSE,
  cambio_aceite BOOLEAN     NOT NULL DEFAULT FALSE,
  cambio_frenos BOOLEAN     NOT NULL DEFAULT FALSE,
  otros         VARCHAR(150),
  matricula     VARCHAR(15) NOT NULL,            -- PASA 1:N
  PRIMARY KEY (cod_revision),
  CONSTRAINT fk_revision_coche FOREIGN KEY (matricula)
    REFERENCES coche(matricula) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
