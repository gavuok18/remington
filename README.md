# Taller de Modelo Entidad-Relación — Implementación en MySQL

Base de datos — Ingeniería de Sistemas · Uniremington

Este repositorio contiene el paso a **MySQL** de los 16 casos del taller de modelo
Entidad-Relación (ejercicios 1 a 22). Cada caso se implementa como una base de datos
independiente, con todas sus tablas, claves primarias, claves foráneas y restricciones.

- Motor: **InnoDB** · Charset: **utf8mb4** (`utf8mb4_spanish_ci`)
- Probado en **MariaDB 10.4 / XAMPP** (phpMyAdmin)
- **16 bases de datos · 82 tablas · 75 claves foráneas**

## Cómo ejecutarlo

Todo de una vez, con el script completo:

```bash
mysql -u root -p < taller_er_mysql.sql
```

O un caso en concreto:

```bash
mysql -u root -p < casos/caso08_biblioteca.sql
```

También se puede importar desde phpMyAdmin (pestaña **Importar** → seleccionar el `.sql`).

> Cada caso empieza con `DROP DATABASE IF EXISTS`, así que el script se puede volver a
> ejecutar desde cero sin errores. Solo afecta a las bases de datos con prefijo `casoNN_`.

## Contenido

| Caso | Ejercicios | Base de datos | Tablas | Estructura del ER |
|:----:|:----------:|---------------|:------:|-------------------|
| 01 | 1 y 7 | [`caso01_ventas`](casos/caso01_ventas.sql) | 4 | N:N cliente–producto → `compra`; proveedor 1:N producto |
| 02 | 2 y 8 | [`caso02_transportes`](casos/caso02_transportes.sql) | 5 | N:N camión–camionero → `conduce` (fecha en la PK) |
| 03 | 3 y 9 | [`caso03_instituto`](casos/caso03_instituto.sql) | 6 | N:N alumno–módulo → `matricula`; `delegado` 1:1 |
| 04 | 4 y 10 | [`caso04_automoviles`](casos/caso04_automoviles.sql) | 3 | cadena de 1:N cliente → coche → revisión |
| 05 | 5 y 11 | [`caso05_clinica`](casos/caso05_clinica.sql) | 3 | `ingreso` recibe las FK de paciente y médico |
| 06 | 6 y 12 | [`caso06_tienda_informatica`](casos/caso06_tienda_informatica.sql) | 5 | dos N:N → `compra` y `suministra` |
| 07 | 13 | [`caso07_personas`](casos/caso07_personas.sql) | 1 | relación reflexiva → FK a sí misma |
| 08 | 14 | [`caso08_biblioteca`](casos/caso08_biblioteca.sql) | 6 | `ejemplar` como entidad débil (PK compuesta) |
| 09 | 15 | [`caso09_concesionario`](casos/caso09_concesionario.sql) | 6 | jerarquía ES-UN total y exclusiva (nuevo/usado) |
| 10 | 16 | [`caso10_liga_futbol`](casos/caso10_liga_futbol.sql) | 5 | doble FK a equipo (local/visitante); 1:1 presidente |
| 11 | 17 | [`caso11_centro_ensenanza`](casos/caso11_centro_ensenanza.sql) | 8 | `matricula`, `horario` (N:N) y `tutor` (1:1) |
| 12 | 18 | [`caso12_empresa`](casos/caso12_empresa.sql) | 7 | N:N empleado–habilidad → `posee`; `dirige` |
| 13 | 19 | [`caso13_hoteles`](casos/caso13_hoteles.sql) | 7 | `habitacion` débil + jerarquía ES-UN de cliente |
| 14 | 20 | [`caso14_seguros`](casos/caso14_seguros.sql) | 7 | tres N:N → `propiedad`, `acc_persona`, `acc_vehiculo` |
| 15 | 21 | [`caso15_agencia_viajes`](casos/caso15_agencia_viajes.sql) | 3 | doble FK a lugar (origen/destino) |
| 16 | 22 | [`caso16_proyectos`](casos/caso16_proyectos.sql) | 6 | N:N proyecto–colaborador → `participa`; pagos |

## Criterios aplicados al pasar del ER al modelo relacional

- **Relaciones 1:N** → clave foránea en la entidad del lado N.
- **Relaciones N:N** → tabla intermedia con PK compuesta por las dos claves foráneas.
  Si la relación tiene atributos propios que permiten repetir la pareja (por ejemplo la
  fecha en `conduce` o en `compra`), ese atributo entra también en la PK.
- **Relaciones 1:1** → tabla propia con la PK de un lado y `UNIQUE` en el otro
  (`delegado`, `tutor`), o `UNIQUE` sobre la FK (`presidente.cod_equipo`). Se resuelve así
  para no crear referencias circulares entre tablas.
- **Entidades débiles** (`ejemplar`, `habitacion`) → PK compuesta que incorpora la clave del
  padre, con borrado en cascada.
- **Jerarquías ES-UN** (`coche`, `cliente`) → tabla padre + una tabla por especialización,
  más una columna discriminante (`tipo_coche`, `tipo_cliente`) por ser totales y exclusivas.
- **Relación reflexiva** (caso 07) → clave foránea de la tabla hacia su propia clave primaria.
- Se añadió `cod_gol` como clave primaria en `gol` (caso 10), porque en el diagrama la
  entidad no tenía identificador propio.
- Interpretación en el caso 12: `UBICADO` es centro de trabajo → departamentos y `DIRIGE`
  es empleado → centros de trabajo (tabla `dirige`).
