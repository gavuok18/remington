-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 06 (ejercicios 6 y 12) - Tienda informatica
--   CLIENTE N:N PRODUCTO -> COMPRA (con fecha_compra)
--   PROVEEDOR N:N PRODUCTO -> SUMINISTRA
-- =====================================================================
DROP DATABASE IF EXISTS caso06_tienda_informatica;
CREATE DATABASE caso06_tienda_informatica CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso06_tienda_informatica;

CREATE TABLE cliente (
  codigo    INT         NOT NULL AUTO_INCREMENT,
  nombre    VARCHAR(50) NOT NULL,
  apellidos VARCHAR(80) NOT NULL,
  direccion VARCHAR(120),
  telefono  VARCHAR(20),
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE producto (
  codigo          INT           NOT NULL AUTO_INCREMENT,
  descripcion     VARCHAR(150)  NOT NULL,
  precio          DECIMAL(10,2) NOT NULL DEFAULT 0,
  num_existencias INT           NOT NULL DEFAULT 0,
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE proveedor (
  codigo    INT         NOT NULL AUTO_INCREMENT,
  nombre    VARCHAR(50) NOT NULL,
  apellidos VARCHAR(80),
  direccion VARCHAR(120),
  provincia VARCHAR(60),
  telefono  VARCHAR(20),
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE compra (                            -- sale de la N:N
  codigo_cliente  INT  NOT NULL,
  codigo_producto INT  NOT NULL,
  fecha_compra    DATE NOT NULL,
  PRIMARY KEY (codigo_cliente, codigo_producto, fecha_compra),
  CONSTRAINT fk_compra_cliente  FOREIGN KEY (codigo_cliente)
    REFERENCES cliente(codigo) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_compra_producto FOREIGN KEY (codigo_producto)
    REFERENCES producto(codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE suministra (                        -- sale de la N:N
  codigo_proveedor INT NOT NULL,
  codigo_producto  INT NOT NULL,
  PRIMARY KEY (codigo_proveedor, codigo_producto),
  CONSTRAINT fk_suministra_proveedor FOREIGN KEY (codigo_proveedor)
    REFERENCES proveedor(codigo) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_suministra_producto  FOREIGN KEY (codigo_producto)
    REFERENCES producto(codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
