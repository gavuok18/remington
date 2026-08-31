-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 15 (ejercicio 21) - Agencia de viajes
--   VIAJERO 1:N VIAJE ; LUGAR 1:N VIAJE dos veces (ORIGEN / DESTINO)
-- =====================================================================
DROP DATABASE IF EXISTS caso15_agencia_viajes;
CREATE DATABASE caso15_agencia_viajes CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso15_agencia_viajes;

CREATE TABLE lugar (
  codigo INT         NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(80) NOT NULL,
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE viajero (
  dni       VARCHAR(15) NOT NULL,
  nombre    VARCHAR(80) NOT NULL,
  direccion VARCHAR(120),
  telefono  VARCHAR(20),
  PRIMARY KEY (dni)
) ENGINE=InnoDB;

CREATE TABLE viaje (
  cod_viaje       INT         NOT NULL AUTO_INCREMENT,
  num_plazas      INT         NOT NULL DEFAULT 1,
  fecha           DATE        NOT NULL,
  dni_viajero     VARCHAR(15) NOT NULL,          -- REALIZA 1:N
  codigo_origen   INT         NOT NULL,          -- ORIGEN 1:N
  codigo_destino  INT         NOT NULL,          -- DESTINO 1:N
  PRIMARY KEY (cod_viaje),
  CONSTRAINT fk_viaje_viajero FOREIGN KEY (dni_viajero)
    REFERENCES viajero(dni) ON UPDATE CASCADE,
  CONSTRAINT fk_viaje_origen  FOREIGN KEY (codigo_origen)
    REFERENCES lugar(codigo) ON UPDATE CASCADE,
  CONSTRAINT fk_viaje_destino FOREIGN KEY (codigo_destino)
    REFERENCES lugar(codigo) ON UPDATE CASCADE,
  CONSTRAINT ck_viaje_lugares CHECK (codigo_origen <> codigo_destino)
) ENGINE=InnoDB;
