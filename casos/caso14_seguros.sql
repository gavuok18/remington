-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 14 (ejercicio 20) - Agencia de seguros: accidentes y multas
--   PERSONA N:N VEHICULO   -> PROPIEDAD (POSEE)
--   ACCIDENTE N:N PERSONA  -> ACC_PERSONA
--   ACCIDENTE N:N VEHICULO -> ACC_VEHICULO
--   PERSONA 1:N MULTA (SANCIONA) ; VEHICULO 1:N MULTA (AFECTA)
-- =====================================================================
DROP DATABASE IF EXISTS caso14_seguros;
CREATE DATABASE caso14_seguros CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso14_seguros;

CREATE TABLE persona (
  dni       VARCHAR(15) NOT NULL,
  nombre    VARCHAR(50) NOT NULL,
  apellidos VARCHAR(80) NOT NULL,
  direccion VARCHAR(120),
  poblacion VARCHAR(60),
  telefono  VARCHAR(20),
  PRIMARY KEY (dni)
) ENGINE=InnoDB;

CREATE TABLE vehiculo (
  matricula VARCHAR(15) NOT NULL,
  marca     VARCHAR(50),
  modelo    VARCHAR(50),
  PRIMARY KEY (matricula)
) ENGINE=InnoDB;

CREATE TABLE accidente (
  num_referencia INT          NOT NULL AUTO_INCREMENT,
  fecha          DATE         NOT NULL,
  lugar          VARCHAR(120),
  hora           TIME,
  PRIMARY KEY (num_referencia)
) ENGINE=InnoDB;

CREATE TABLE multa (
  num_referencia   INT           NOT NULL AUTO_INCREMENT,
  fecha            DATE          NOT NULL,
  hora             TIME,
  lugar_infraccion VARCHAR(120),
  importe          DECIMAL(10,2) NOT NULL DEFAULT 0,
  dni              VARCHAR(15)   NOT NULL,       -- SANCIONA 1:N
  matricula        VARCHAR(15)   NOT NULL,       -- AFECTA 1:N
  PRIMARY KEY (num_referencia),
  CONSTRAINT fk_multa_persona  FOREIGN KEY (dni)
    REFERENCES persona(dni) ON UPDATE CASCADE,
  CONSTRAINT fk_multa_vehiculo FOREIGN KEY (matricula)
    REFERENCES vehiculo(matricula) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE propiedad (                         -- sale de POSEE (N:N)
  dni       VARCHAR(15) NOT NULL,
  matricula VARCHAR(15) NOT NULL,
  PRIMARY KEY (dni, matricula),
  CONSTRAINT fk_propiedad_persona  FOREIGN KEY (dni)
    REFERENCES persona(dni) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_propiedad_vehiculo FOREIGN KEY (matricula)
    REFERENCES vehiculo(matricula) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE acc_persona (                       -- sale de IMPLICA (N:N)
  num_referencia INT         NOT NULL,
  dni            VARCHAR(15) NOT NULL,
  PRIMARY KEY (num_referencia, dni),
  CONSTRAINT fk_accpersona_accidente FOREIGN KEY (num_referencia)
    REFERENCES accidente(num_referencia) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_accpersona_persona   FOREIGN KEY (dni)
    REFERENCES persona(dni) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE acc_vehiculo (                      -- sale de IMPLICA (N:N)
  num_referencia INT         NOT NULL,
  matricula      VARCHAR(15) NOT NULL,
  PRIMARY KEY (num_referencia, matricula),
  CONSTRAINT fk_accvehiculo_accidente FOREIGN KEY (num_referencia)
    REFERENCES accidente(num_referencia) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_accvehiculo_vehiculo  FOREIGN KEY (matricula)
    REFERENCES vehiculo(matricula) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
