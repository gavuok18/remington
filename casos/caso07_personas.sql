-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 07 (ejercicio 13) - Relacion reflexiva: PERSONA tiene hijos
--   1:N sobre si misma -> FK recursiva dni_progenitor
-- =====================================================================
DROP DATABASE IF EXISTS caso07_personas;
CREATE DATABASE caso07_personas CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso07_personas;

CREATE TABLE persona (
  dni            VARCHAR(15) NOT NULL,
  nombre         VARCHAR(80) NOT NULL,
  direccion      VARCHAR(120),
  telefono       VARCHAR(20),
  dni_progenitor VARCHAR(15) NULL,               -- padre/madre (lado 1)
  PRIMARY KEY (dni),
  CONSTRAINT fk_persona_progenitor FOREIGN KEY (dni_progenitor)
    REFERENCES persona(dni) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;
