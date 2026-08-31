-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 13 (ejercicio 19) - Cadena de hoteles
--   CATEGORIA 1:N HOTEL ; HOTEL 1:N HABITACION (entidad debil)
--   CLIENTE N:N HABITACION -> RESERVA
--   ES-UN: CLIENTE -> PARTICULAR / AGENCIA_VIAJES (sin atributos)
-- =====================================================================
DROP DATABASE IF EXISTS caso13_hoteles;
CREATE DATABASE caso13_hoteles CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso13_hoteles;

CREATE TABLE categoria (
  cod_categoria INT          NOT NULL AUTO_INCREMENT,
  descripcion   VARCHAR(100) NOT NULL,
  tipo_iva      DECIMAL(5,2),
  PRIMARY KEY (cod_categoria)
) ENGINE=InnoDB;

CREATE TABLE hotel (
  cod_hotel         INT         NOT NULL AUTO_INCREMENT,
  nombre            VARCHAR(80) NOT NULL,
  direccion         VARCHAR(120),
  telefono          VARCHAR(20),
  anio_construccion YEAR,
  cod_categoria     INT,                         -- CLASIFICADO 1:N
  PRIMARY KEY (cod_hotel),
  CONSTRAINT fk_hotel_categoria FOREIGN KEY (cod_categoria)
    REFERENCES categoria(cod_categoria) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE habitacion (                        -- entidad debil de HOTEL
  cod_hotel INT         NOT NULL,
  codigo    INT         NOT NULL,
  tipo      VARCHAR(30),
  planta    INT,
  PRIMARY KEY (cod_hotel, codigo),
  CONSTRAINT fk_habitacion_hotel FOREIGN KEY (cod_hotel)
    REFERENCES hotel(cod_hotel) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE cliente (
  cod_cliente  INT         NOT NULL AUTO_INCREMENT,
  nombre       VARCHAR(80) NOT NULL,
  direccion    VARCHAR(120),
  telefono     VARCHAR(20),
  tipo_cliente ENUM('PARTICULAR','AGENCIA') NOT NULL,   -- discriminante
  PRIMARY KEY (cod_cliente)
) ENGINE=InnoDB;

CREATE TABLE particular (
  cod_cliente INT NOT NULL,
  PRIMARY KEY (cod_cliente),
  CONSTRAINT fk_particular_cliente FOREIGN KEY (cod_cliente)
    REFERENCES cliente(cod_cliente) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE agencia_viajes (
  cod_cliente INT NOT NULL,
  PRIMARY KEY (cod_cliente),
  CONSTRAINT fk_agencia_cliente FOREIGN KEY (cod_cliente)
    REFERENCES cliente(cod_cliente) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE reserva (                           -- sale de la N:N
  cod_cliente       INT           NOT NULL,
  cod_hotel         INT           NOT NULL,
  codigo_habitacion INT           NOT NULL,
  fecha_inicio      DATE          NOT NULL,
  fecha_fin         DATE          NOT NULL,
  precio            DECIMAL(10,2),
  nombre_persona    VARCHAR(80),
  PRIMARY KEY (cod_cliente, cod_hotel, codigo_habitacion, fecha_inicio),
  CONSTRAINT fk_reserva_cliente    FOREIGN KEY (cod_cliente)
    REFERENCES cliente(cod_cliente) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_reserva_habitacion FOREIGN KEY (cod_hotel, codigo_habitacion)
    REFERENCES habitacion(cod_hotel, codigo) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT ck_reserva_fechas CHECK (fecha_fin >= fecha_inicio)
) ENGINE=InnoDB;
