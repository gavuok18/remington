-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 09 (ejercicio 15) - Concesionario con taller y jerarquia
--   CLIENTE 1:N COCHE ; COCHE N:N MECANICO -> REPARA
--   ES-UN total y exclusiva: COCHE -> COCHE_NUEVO / COCHE_USADO
-- =====================================================================
DROP DATABASE IF EXISTS caso09_concesionario;
CREATE DATABASE caso09_concesionario CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso09_concesionario;

CREATE TABLE cliente (
  dni       VARCHAR(15) NOT NULL,
  nombre    VARCHAR(50) NOT NULL,
  apellidos VARCHAR(80) NOT NULL,
  direccion VARCHAR(120),
  telefono  VARCHAR(20),
  PRIMARY KEY (dni)
) ENGINE=InnoDB;

CREATE TABLE coche (
  matricula   VARCHAR(15) NOT NULL,
  modelo      VARCHAR(50),
  marca       VARCHAR(50),
  color       VARCHAR(30),
  dni_cliente VARCHAR(15),                       -- COMPRA 1:N
  -- discriminante de la jerarquia (total + exclusiva)
  tipo_coche  ENUM('NUEVO','USADO') NOT NULL,
  PRIMARY KEY (matricula),
  CONSTRAINT fk_coche_cliente FOREIGN KEY (dni_cliente)
    REFERENCES cliente(dni) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE coche_nuevo (
  matricula    VARCHAR(15) NOT NULL,
  num_unidades INT         NOT NULL DEFAULT 1,
  PRIMARY KEY (matricula),
  CONSTRAINT fk_cochenuevo_coche FOREIGN KEY (matricula)
    REFERENCES coche(matricula) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE coche_usado (
  matricula     VARCHAR(15) NOT NULL,
  km_recorridos INT         NOT NULL DEFAULT 0,
  PRIMARY KEY (matricula),
  CONSTRAINT fk_cocheusado_coche FOREIGN KEY (matricula)
    REFERENCES coche(matricula) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE mecanico (
  dni                VARCHAR(15) NOT NULL,
  nombre             VARCHAR(50) NOT NULL,
  apellidos          VARCHAR(80) NOT NULL,
  fecha_contratacion DATE,
  salario            DECIMAL(10,2),
  PRIMARY KEY (dni)
) ENGINE=InnoDB;

CREATE TABLE repara (                            -- sale de la N:N
  matricula    VARCHAR(15) NOT NULL,
  dni_mecanico VARCHAR(15) NOT NULL,
  fecha        DATE        NOT NULL,
  num_horas    DECIMAL(5,2),
  PRIMARY KEY (matricula, dni_mecanico, fecha),
  CONSTRAINT fk_repara_coche    FOREIGN KEY (matricula)
    REFERENCES coche(matricula) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_repara_mecanico FOREIGN KEY (dni_mecanico)
    REFERENCES mecanico(dni) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
