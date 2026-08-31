-- =====================================================================
--  TALLER DE MODELO ENTIDAD-RELACION  ->  IMPLEMENTACION EN MySQL
--  16 casos (ejercicios 1 a 22) -> una base de datos por caso
--  Motor: InnoDB / Charset: utf8mb4
--
--  OJO: cada caso empieza con DROP DATABASE IF EXISTS, asi el script se
--  puede volver a ejecutar desde cero. Solo borra las BD "casoNN_...".
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

-- =====================================================================
-- CASO 02 (ejercicios 2 y 8) - Empresa de transportes
--   CAMION N:N CAMIONERO -> CONDUCE (con fecha en la PK)
--   CAMIONERO 1:N PAQUETE / PROVINCIA 1:N PAQUETE (LLEGA)
-- =====================================================================
DROP DATABASE IF EXISTS caso02_transportes;
CREATE DATABASE caso02_transportes CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso02_transportes;

CREATE TABLE camion (
  matricula VARCHAR(15) NOT NULL,
  modelo    VARCHAR(50),
  tipo      VARCHAR(50),
  potencia  INT,
  PRIMARY KEY (matricula)
) ENGINE=InnoDB;

CREATE TABLE camionero (
  dni       VARCHAR(15)  NOT NULL,
  nombre    VARCHAR(80)  NOT NULL,
  telefono  VARCHAR(20),
  direccion VARCHAR(120),
  salario   DECIMAL(10,2),
  poblacion VARCHAR(60),
  PRIMARY KEY (dni)
) ENGINE=InnoDB;

CREATE TABLE provincia (
  cod_provincia INT         NOT NULL,
  nombre        VARCHAR(60) NOT NULL,
  PRIMARY KEY (cod_provincia)
) ENGINE=InnoDB;

CREATE TABLE paquete (
  cod_paquete      INT          NOT NULL AUTO_INCREMENT,
  descripcion      VARCHAR(150),
  destinatario     VARCHAR(80)  NOT NULL,
  dir_destinatario VARCHAR(120),
  dni_camionero    VARCHAR(15)  NOT NULL,        -- DISTRIBUYE 1:N
  cod_provincia    INT          NOT NULL,        -- LLEGA 1:N
  PRIMARY KEY (cod_paquete),
  CONSTRAINT fk_paquete_camionero FOREIGN KEY (dni_camionero)
    REFERENCES camionero(dni) ON UPDATE CASCADE,
  CONSTRAINT fk_paquete_provincia FOREIGN KEY (cod_provincia)
    REFERENCES provincia(cod_provincia) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE conduce (                           -- sale de la N:N
  dni       VARCHAR(15) NOT NULL,
  matricula VARCHAR(15) NOT NULL,
  fecha     DATE        NOT NULL,
  PRIMARY KEY (dni, matricula, fecha),
  CONSTRAINT fk_conduce_camionero FOREIGN KEY (dni)
    REFERENCES camionero(dni) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_conduce_camion FOREIGN KEY (matricula)
    REFERENCES camion(matricula) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- CASO 03 (ejercicios 3 y 9) - Instituto: profesores, modulos y cursos
--   PROFESOR 1:N MODULO / CURSO 1:N ALUMNO
--   ALUMNO N:N MODULO -> MATRICULA        DELEGADO 1:1 CURSO-ALUMNO
-- =====================================================================
DROP DATABASE IF EXISTS caso03_instituto;
CREATE DATABASE caso03_instituto CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso03_instituto;

CREATE TABLE profesor (
  dni       VARCHAR(15) NOT NULL,
  nombre    VARCHAR(80) NOT NULL,
  direccion VARCHAR(120),
  telefono  VARCHAR(20),
  PRIMARY KEY (dni)
) ENGINE=InnoDB;

CREATE TABLE modulo (
  codigo       INT         NOT NULL AUTO_INCREMENT,
  nombre       VARCHAR(80) NOT NULL,
  dni_profesor VARCHAR(15),                      -- IMPARTE 1:N
  PRIMARY KEY (codigo),
  CONSTRAINT fk_modulo_profesor FOREIGN KEY (dni_profesor)
    REFERENCES profesor(dni) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE curso (
  codigo INT         NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(80) NOT NULL,
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE alumno (
  num_expediente   INT         NOT NULL AUTO_INCREMENT,
  nombre           VARCHAR(50) NOT NULL,
  apellidos        VARCHAR(80) NOT NULL,
  fecha_nacimiento DATE,
  codigo_curso     INT,                          -- PERTENECE 1:N
  PRIMARY KEY (num_expediente),
  CONSTRAINT fk_alumno_curso FOREIGN KEY (codigo_curso)
    REFERENCES curso(codigo) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE delegado (                          -- 1:1 -> PK + UNIQUE
  codigo_curso   INT NOT NULL,
  num_expediente INT NOT NULL,
  PRIMARY KEY (codigo_curso),
  UNIQUE KEY uq_delegado_alumno (num_expediente),
  CONSTRAINT fk_delegado_curso  FOREIGN KEY (codigo_curso)
    REFERENCES curso(codigo) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_delegado_alumno FOREIGN KEY (num_expediente)
    REFERENCES alumno(num_expediente) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE matricula (                         -- sale de la N:N
  num_expediente INT NOT NULL,
  codigo_modulo  INT NOT NULL,
  PRIMARY KEY (num_expediente, codigo_modulo),
  CONSTRAINT fk_matricula_alumno FOREIGN KEY (num_expediente)
    REFERENCES alumno(num_expediente) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_matricula_modulo FOREIGN KEY (codigo_modulo)
    REFERENCES modulo(codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

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

-- =====================================================================
-- CASO 05 (ejercicios 5 y 11) - Clinica San Patras
--   PACIENTE 1:N INGRESO ; MEDICO 1:N INGRESO
-- =====================================================================
DROP DATABASE IF EXISTS caso05_clinica;
CREATE DATABASE caso05_clinica CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso05_clinica;

CREATE TABLE paciente (
  codigo           INT         NOT NULL AUTO_INCREMENT,
  nombre           VARCHAR(50) NOT NULL,
  apellidos        VARCHAR(80) NOT NULL,
  direccion        VARCHAR(120),
  poblacion        VARCHAR(60),
  provincia        VARCHAR(60),
  cod_postal       VARCHAR(10),
  telefono         VARCHAR(20),
  fecha_nacimiento DATE,
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE medico (
  codigo       INT         NOT NULL AUTO_INCREMENT,
  nombre       VARCHAR(50) NOT NULL,
  apellidos    VARCHAR(80) NOT NULL,
  telefono     VARCHAR(20),
  especialidad VARCHAR(60),
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE ingreso (
  cod_ingreso     INT         NOT NULL AUTO_INCREMENT,
  habitacion      VARCHAR(10),
  cama            VARCHAR(10),
  fecha_ingreso   DATE        NOT NULL,
  codigo_paciente INT         NOT NULL,          -- REALIZA 1:N
  codigo_medico   INT         NOT NULL,          -- ATIENDE 1:N
  PRIMARY KEY (cod_ingreso),
  CONSTRAINT fk_ingreso_paciente FOREIGN KEY (codigo_paciente)
    REFERENCES paciente(codigo) ON UPDATE CASCADE,
  CONSTRAINT fk_ingreso_medico   FOREIGN KEY (codigo_medico)
    REFERENCES medico(codigo) ON UPDATE CASCADE
) ENGINE=InnoDB;

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

-- =====================================================================
-- CASO 08 (ejercicio 14) - Biblioteca del centro
--   AUTOR N:N LIBRO -> ESCRIBE
--   LIBRO 1:N EJEMPLAR (entidad debil: PK compuesta)
--   USUARIO N:N EJEMPLAR -> PRESTAMO
-- =====================================================================
DROP DATABASE IF EXISTS caso08_biblioteca;
CREATE DATABASE caso08_biblioteca CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso08_biblioteca;

CREATE TABLE autor (
  cod_autor INT         NOT NULL AUTO_INCREMENT,
  nombre    VARCHAR(80) NOT NULL,
  PRIMARY KEY (cod_autor)
) ENGINE=InnoDB;

CREATE TABLE libro (
  codigo      INT          NOT NULL AUTO_INCREMENT,
  titulo      VARCHAR(150) NOT NULL,
  isbn        VARCHAR(20),
  editorial   VARCHAR(80),
  num_paginas INT,
  PRIMARY KEY (codigo),
  UNIQUE KEY uq_libro_isbn (isbn)
) ENGINE=InnoDB;

CREATE TABLE ejemplar (                          -- entidad debil de LIBRO
  codigo_libro INT         NOT NULL,
  codigo       INT         NOT NULL,
  localizacion VARCHAR(80),
  PRIMARY KEY (codigo_libro, codigo),
  CONSTRAINT fk_ejemplar_libro FOREIGN KEY (codigo_libro)
    REFERENCES libro(codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE usuario (
  codigo    INT         NOT NULL AUTO_INCREMENT,
  nombre    VARCHAR(80) NOT NULL,
  direccion VARCHAR(120),
  telefono  VARCHAR(20),
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE escribe (                           -- sale de la N:N
  cod_autor    INT NOT NULL,
  codigo_libro INT NOT NULL,
  PRIMARY KEY (cod_autor, codigo_libro),
  CONSTRAINT fk_escribe_autor FOREIGN KEY (cod_autor)
    REFERENCES autor(cod_autor) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_escribe_libro FOREIGN KEY (codigo_libro)
    REFERENCES libro(codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE prestamo (                          -- sale de la N:N
  codigo_usuario   INT  NOT NULL,
  codigo_libro     INT  NOT NULL,
  codigo_ejemplar  INT  NOT NULL,
  fecha_prestamo   DATE NOT NULL,
  fecha_devolucion DATE NULL,
  PRIMARY KEY (codigo_usuario, codigo_libro, codigo_ejemplar, fecha_prestamo),
  CONSTRAINT fk_prestamo_usuario  FOREIGN KEY (codigo_usuario)
    REFERENCES usuario(codigo) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_prestamo_ejemplar FOREIGN KEY (codigo_libro, codigo_ejemplar)
    REFERENCES ejemplar(codigo_libro, codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

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

-- =====================================================================
-- CASO 10 (ejercicio 16) - Liga de futbol profesional
--   PRESIDENTE 1:1 EQUIPO ; EQUIPO 1:N JUGADOR
--   EQUIPO 1:N PARTIDO dos veces (LOCAL y VISITANTE)
--   PARTIDO 1:N GOL ; JUGADOR 1:N GOL (MARCA)
-- =====================================================================
DROP DATABASE IF EXISTS caso10_liga_futbol;
CREATE DATABASE caso10_liga_futbol CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso10_liga_futbol;

CREATE TABLE equipo (
  cod_equipo     INT         NOT NULL AUTO_INCREMENT,
  nombre         VARCHAR(80) NOT NULL,
  estadio        VARCHAR(80),
  aforo          INT,
  anio_fundacion YEAR,
  ciudad         VARCHAR(60),
  PRIMARY KEY (cod_equipo)
) ENGINE=InnoDB;

CREATE TABLE presidente (
  dni              VARCHAR(15) NOT NULL,
  nombre           VARCHAR(50) NOT NULL,
  apellidos        VARCHAR(80) NOT NULL,
  fecha_nacimiento DATE,
  anio_eleccion    YEAR,
  cod_equipo       INT         NOT NULL,         -- PRESIDE 1:1
  PRIMARY KEY (dni),
  UNIQUE KEY uq_presidente_equipo (cod_equipo),  -- garantiza el 1:1
  CONSTRAINT fk_presidente_equipo FOREIGN KEY (cod_equipo)
    REFERENCES equipo(cod_equipo) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE jugador (
  cod_jugador      INT         NOT NULL AUTO_INCREMENT,
  nombre           VARCHAR(80) NOT NULL,
  fecha_nacimiento DATE,
  posicion         VARCHAR(30),
  cod_equipo       INT,                          -- PERTENECE 1:N
  PRIMARY KEY (cod_jugador),
  CONSTRAINT fk_jugador_equipo FOREIGN KEY (cod_equipo)
    REFERENCES equipo(cod_equipo) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE partido (
  cod_partido          INT  NOT NULL AUTO_INCREMENT,
  fecha                DATE NOT NULL,
  goles_local          INT  NOT NULL DEFAULT 0,
  goles_visitante      INT  NOT NULL DEFAULT 0,
  cod_equipo_local     INT  NOT NULL,            -- LOCAL 1:N
  cod_equipo_visitante INT  NOT NULL,            -- VISITANTE 1:N
  PRIMARY KEY (cod_partido),
  CONSTRAINT fk_partido_local     FOREIGN KEY (cod_equipo_local)
    REFERENCES equipo(cod_equipo) ON UPDATE CASCADE,
  CONSTRAINT fk_partido_visitante FOREIGN KEY (cod_equipo_visitante)
    REFERENCES equipo(cod_equipo) ON UPDATE CASCADE,
  CONSTRAINT ck_partido_equipos CHECK (cod_equipo_local <> cod_equipo_visitante)
) ENGINE=InnoDB;

CREATE TABLE gol (
  cod_gol     INT          NOT NULL AUTO_INCREMENT,  -- PK propia
  minuto      INT          NOT NULL,
  descripcion VARCHAR(150),
  cod_partido INT          NOT NULL,             -- TIENE 1:N
  cod_jugador INT          NOT NULL,             -- MARCA 1:N
  PRIMARY KEY (cod_gol),
  CONSTRAINT fk_gol_partido FOREIGN KEY (cod_partido)
    REFERENCES partido(cod_partido) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_gol_jugador FOREIGN KEY (cod_jugador)
    REFERENCES jugador(cod_jugador) ON UPDATE CASCADE
) ENGINE=InnoDB;

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

-- =====================================================================
-- CASO 12 (ejercicio 18) - Organizacion interna de una empresa
--   CENTRO_TRABAJO 1:N DEPARTAMENTO (UBICADO)
--   DEPARTAMENTO 1:N EMPLEADO (ASIGNADO) ; EMPLEADO 1:N HIJO
--   EMPLEADO 1:N CENTRO_TRABAJO (DIRIGE) -> tabla DIRIGE
--   EMPLEADO N:N HABILIDAD -> POSEE
-- =====================================================================
DROP DATABASE IF EXISTS caso12_empresa;
CREATE DATABASE caso12_empresa CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE caso12_empresa;

CREATE TABLE centro_trabajo (
  cod_centro INT         NOT NULL AUTO_INCREMENT,
  nombre     VARCHAR(80) NOT NULL,
  poblacion  VARCHAR(60),
  direccion  VARCHAR(120),
  PRIMARY KEY (cod_centro)
) ENGINE=InnoDB;

CREATE TABLE departamento (
  codigo             INT           NOT NULL AUTO_INCREMENT,
  nombre             VARCHAR(80)   NOT NULL,
  presupuesto_anual  DECIMAL(12,2),
  cod_centro         INT,                        -- UBICADO 1:N
  PRIMARY KEY (codigo),
  CONSTRAINT fk_departamento_centro FOREIGN KEY (cod_centro)
    REFERENCES centro_trabajo(cod_centro) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE empleado (
  nif                 VARCHAR(15) NOT NULL,
  nombre              VARCHAR(80) NOT NULL,
  telefono            VARCHAR(20),
  fecha_alta          DATE,
  salario             DECIMAL(10,2),
  num_hijos           INT         NOT NULL DEFAULT 0,
  codigo_departamento INT,                       -- ASIGNADO 1:N
  PRIMARY KEY (nif),
  CONSTRAINT fk_empleado_departamento FOREIGN KEY (codigo_departamento)
    REFERENCES departamento(codigo) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE dirige (                            -- 1:N EMPLEADO-CENTRO
  cod_centro INT         NOT NULL,
  nif        VARCHAR(15) NOT NULL,
  PRIMARY KEY (cod_centro),
  CONSTRAINT fk_dirige_centro   FOREIGN KEY (cod_centro)
    REFERENCES centro_trabajo(cod_centro) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_dirige_empleado FOREIGN KEY (nif)
    REFERENCES empleado(nif) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE hijo (
  codigo           INT         NOT NULL AUTO_INCREMENT,
  nombre           VARCHAR(80) NOT NULL,
  fecha_nacimiento DATE,
  nif_empleado     VARCHAR(15) NOT NULL,         -- TIENE 1:N
  PRIMARY KEY (codigo),
  CONSTRAINT fk_hijo_empleado FOREIGN KEY (nif_empleado)
    REFERENCES empleado(nif) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE habilidad (
  codigo      INT          NOT NULL AUTO_INCREMENT,
  descripcion VARCHAR(150) NOT NULL,
  PRIMARY KEY (codigo)
) ENGINE=InnoDB;

CREATE TABLE posee (                             -- sale de la N:N
  nif              VARCHAR(15) NOT NULL,
  codigo_habilidad INT         NOT NULL,
  PRIMARY KEY (nif, codigo_habilidad),
  CONSTRAINT fk_posee_empleado  FOREIGN KEY (nif)
    REFERENCES empleado(nif) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_posee_habilidad FOREIGN KEY (codigo_habilidad)
    REFERENCES habilidad(codigo) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

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

-- =====================================================================
-- FIN DEL SCRIPT
-- =====================================================================
