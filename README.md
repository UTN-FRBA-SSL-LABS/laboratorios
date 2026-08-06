# Laboratorios de Sintaxis y Semántica de los Lenguajes

Este repositorio reúne en un único lugar los laboratorios prácticos de SSL de
UTN FRBA. Cada laboratorio conserva su contenido y su historial, pero comparte
la integración continua del repositorio.

## Laboratorios

| Laboratorio | Carpeta | Verificación local |
| --- | --- | --- |
| Git y GitHub | [`labs/lab-github`](labs/lab-github) | `cd labs/lab-github && make test` |
| Proceso de compilación en C | [`labs/lab-compilacion-c`](labs/lab-compilacion-c) | `cd labs/lab-compilacion-c && make test` |
| Strings en C | [`labs/lab-string`](labs/lab-string) | `cd labs/lab-string && make test` |
| Testing en C | [`labs/laboratorio-testing-c`](labs/laboratorio-testing-c) | `cd labs/laboratorio-testing-c && make test` |
| Make | [`labs/lab-make`](labs/lab-make) | `cd labs/lab-make && make test` |
| Flex | [`labs/lab-flex`](labs/lab-flex) | `cd labs/lab-flex && make test` |
| Bison | [`labs/lab-bison`](labs/lab-bison) | `cd labs/lab-bison && make test` |

## Integración continua

El repositorio tiene un único workflow en `.github/workflows/labs-ci.yml`.
Ante cada push, identifica las carpetas modificadas y ejecuta solamente esos
laboratorios. Si cambia la infraestructura de grading, ejecuta los siete para
validar la configuración completa.

El mismo grading puede ejecutarse localmente desde la raíz, sin hacer push:

```bash
make grade LAB=lab-flex
```

La salida legible y el JSON quedan en `calificaciones/`. Los verificadores
consideran aprobado un puntaje de 60 o más; se puede ensayar otro mínimo con
`MIN_SCORE=80 make grade LAB=lab-flex`.

## Forma de trabajo

1. Clonar este repositorio una sola vez.
2. Entrar en la carpeta del laboratorio asignado.
3. Trabajar y ejecutar `make test` desde el lab o `make grade LAB=<lab>` desde la raíz.
4. Commitear únicamente los archivos correspondientes al laboratorio.
5. Revisar el job `Grading · <nombre-del-laboratorio>` en la pestaña **Actions**.

La procedencia de cada carpeta y las decisiones de migración están documentadas
en [`docs/MIGRACION.md`](docs/MIGRACION.md). El formato y consumo automático de
notas se describe en [`docs/CALIFICACIONES.md`](docs/CALIFICACIONES.md).
