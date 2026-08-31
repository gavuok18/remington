-- =====================================================================
-- Taller de modelo Entidad-Relacion -> MySQL
-- Fragmento extraido de taller_er_mysql.sql (script completo)
-- =====================================================================

-- =====================================================================
-- CASO 11 (ejercicio 17) - Centro de ensenanza
--   PROFESOR 1:N ASIGNATURA ; TUTOR 1:1 PROFESOR-CURSO
--   CURSO 1:N ALUMNO ; ALUMNO N:N ASIGNATURA -> MATRICULA
--   ASIGNATURA N:N AULA -> HORARIO
-- =====================================================================
DROP DATABASE IF EXISTS caso11_centro_ensenanza;
CREATE DATABASE caso11_centro_ensenanza CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso11_centro_ensenanza;

CREATE TABLE profesor (
  dni              VARCHAR(15) NOT NULL,
  nombre           VARCHAR(50) NOT NULL,
  apellidos        VARCHAR(80) NOT NULL,
  direccion        VARCHAR(120),
  poblacion        VARCHAR(60),
  cod_postal       VARCHAR(10),
  telefono         VARCHAR(20),
  fecha_nacimiento DATE,
  PRIMARY KEY (dni)
) ENGINE=InnoDB;

CREATE TABLE asignatura (
  cod_asignatura INT         NOT NULL AUTO_INCREMENT,
  nombre         VARCHAR(80) NOT NULL,
  num_horas      INT,
  dni_profesor   VARCHAR(15),                    -- IMPARTE 1:N
  PRIMARY KEY (cod_asignatura),
  CONSTRAINT fk_asignatura_profesor FOREIGN KEY (dni_profesor)
    REFERENCES profesor(dni) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE aula (
  codigo       INT NOT NULL AUTO_INCREMENT,
  piso         INT,
  num_pupitres INT,
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE curso (
  codigo INT         NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(80) NOT NULL,
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE tutor (                             -- 1:1 PROFESOR-CURSO
  codigo_curso INT         NOT NULL,
  dni_profesor VARCHAR(15) NOT NULL,
  PRIMARY KEY (codigo_curso),
  UNIQUE KEY uq_tutor_profesor (dni_profesor),
  CONSTRAINT fk_tutor_curso    FOREIGN KEY (codigo_curso)
    REFERENCES curso(codigo) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_tutor_profesor FOREIGN KEY (dni_profesor)
    REFERENCES profesor(dni) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE alumno (
  dni              VARCHAR(15) NOT NULL,
  nombre           VARCHAR(50) NOT NULL,
  apellidos        VARCHAR(80) NOT NULL,
  direccion        VARCHAR(120),
  poblacion        VARCHAR(60),
  cod_postal       VARCHAR(10),
  telefono         VARCHAR(20),
  fecha_nacimiento DATE,
  codigo_curso     INT,                          -- PERTENECE 1:N
  PRIMARY KEY (dni),
  CONSTRAINT fk_alumno_curso FOREIGN KEY (codigo_curso)
    REFERENCES curso(codigo) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE matricula (                         -- sale de la N:N
  dni_alumno     VARCHAR(15)  NOT NULL,
  cod_asignatura INT          NOT NULL,
  nota           DECIMAL(4,2),
  incidencias    VARCHAR(200),
  PRIMARY KEY (dni_alumno, cod_asignatura),
  CONSTRAINT fk_matricula_alumno     FOREIGN KEY (dni_alumno)
    REFERENCES alumno(dni) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_matricula_asignatura FOREIGN KEY (cod_asignatura)
    REFERENCES asignatura(cod_asignatura) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE horario (                           -- sale de la N:N
  cod_asignatura INT NOT NULL,
  codigo_aula    INT NOT NULL,
  mes            TINYINT     NOT NULL,
  dia            TINYINT     NOT NULL,
  hora           TIME        NOT NULL,
  PRIMARY KEY (cod_asignatura, codigo_aula, mes, dia, hora),
  CONSTRAINT fk_horario_asignatura FOREIGN KEY (cod_asignatura)
    REFERENCES asignatura(cod_asignatura) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_horario_aula       FOREIGN KEY (codigo_aula)
    REFERENCES aula(codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
