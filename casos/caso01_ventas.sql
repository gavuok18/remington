-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 01 (ejercicios 1 y 7) - Venta de productos a clientes
--   CLIENTE  N:N  PRODUCTO      -> tabla intermedia COMPRA
--   PROVEEDOR 1:N PRODUCTO      -> FK en PRODUCTO
-- =====================================================================
DROP DATABASE IF EXISTS caso01_ventas;
CREATE DATABASE caso01_ventas CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso01_ventas;

CREATE TABLE cliente (
  dni              VARCHAR(15)  NOT NULL,
  nombre           VARCHAR(50)  NOT NULL,
  apellidos        VARCHAR(80)  NOT NULL,
  direccion        VARCHAR(120),
  fecha_nacimiento DATE,
  PRIMARY KEY (dni)
) ENGINE=InnoDB;

CREATE TABLE proveedor (
  nif       VARCHAR(15)  NOT NULL,
  nombre    VARCHAR(80)  NOT NULL,
  direccion VARCHAR(120),
  PRIMARY KEY (nif)
) ENGINE=InnoDB;

CREATE TABLE producto (
  codigo          INT           NOT NULL AUTO_INCREMENT,
  nombre          VARCHAR(80)   NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL DEFAULT 0,
  nif_proveedor   VARCHAR(15)   NOT NULL,        -- SUMINISTRA 1:N
  PRIMARY KEY (codigo),
  CONSTRAINT fk_producto_proveedor FOREIGN KEY (nif_proveedor)
    REFERENCES proveedor(nif) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE compra (                            -- sale de la N:N
  dni_cliente     VARCHAR(15) NOT NULL,
  codigo_producto INT         NOT NULL,
  PRIMARY KEY (dni_cliente, codigo_producto),
  CONSTRAINT fk_compra_cliente  FOREIGN KEY (dni_cliente)
    REFERENCES cliente(dni) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_compra_producto FOREIGN KEY (codigo_producto)
    REFERENCES producto(codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
