# Laboratorio: Testing en C

## Verificación y calificación

Desde la raíz del repositorio ejecutá:

```bash
make grade LAB=laboratorio-testing-c
```

Si ya estás dentro de esta carpeta también podés usar `make test`. Ambos
comandos ejecutan los mismos checks y muestran el puntaje sin necesidad de hacer
push. La verificación oficial se ejecuta cuando cambia
`labs/laboratorio-testing-c/`; la nota queda en el resumen y en los artefactos
de GitHub Actions.

No modifiques `.github/`, `scripts/` ni `test_local.sh`: son infraestructura
docente protegida y no forman parte de la entrega.

## Enunciado

El desarrollo completo del laboratorio y las respuestas que se deben completar
están en [`proceso_testing.md`](proceso_testing.md).

## Requisitos

- GCC
- Make
- Bash

Para comenzar:

```bash
make test
```
