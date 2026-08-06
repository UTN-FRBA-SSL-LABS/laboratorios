# Migración a monorepo

## Alcance

Se consolidaron los siete repositorios base de la organización
`UTN-FRBA-SSL-LABS`. No se importaron los repositorios personales creados por
GitHub Classroom, porque contienen entregas de estudiantes y no son fuentes del
material del curso.

| Carpeta nueva | Repositorio de origen | Commit importado |
| --- | --- | --- |
| `labs/lab-github` | `UTN-FRBA-SSL-LABS/lab-github` | `7ec4677a44fc67f51e6cb48cc724856f62447034` |
| `labs/lab-compilacion-c` | `UTN-FRBA-SSL-LABS/lab-compilacion-c` | `0e2a470e1048374e098e69ff71e8cb088bc8e277` |
| `labs/lab-string` | `UTN-FRBA-SSL-LABS/lab-string` | `cda5538a9f80deb40b2cf17f021627185d7961f7` |
| `labs/laboratorio-testing-c` | `UTN-FRBA-SSL-LABS/laboratorio-testing-c` | `83d241fd3d73946a88ea4cb92ae962c22e814484` |
| `labs/lab-make` | `UTN-FRBA-SSL-LABS/lab-make` | `7a50ab70eccec1a1e2966ae94d0b923b8d7e13a7` |
| `labs/lab-flex` | `UTN-FRBA-SSL-LABS/lab-flex` | `3030a83b36da4933cfa878efde306ba8508e350c` |
| `labs/lab-bison` | `UTN-FRBA-SSL-LABS/lab-bison` | `9156f04d2f5372e8b73cd54e0aaee63ce7b196b1` |

Las importaciones se hicieron con `git subtree`, por lo que los commits de los
repositorios originales siguen disponibles en el historial del monorepo.

## Cambios deliberados

- Se eliminaron de cada laboratorio `.github/classroom/autograding.json` y
  `.github/workflows/classroom.yml`.
- Se agregó un único workflow raíz que selecciona laboratorios por sus paths.
- `test_local.sh` devuelve un código de error cuando el puntaje queda por debajo
  de `MIN_SCORE` (60 por defecto), de modo que el mismo verificador sirve tanto
  localmente como en CI.
- La documentación de cada laboratorio ahora apunta al job central de CI.

## Publicación y transición

1. Crear un repositorio vacío en la organización:
   `UTN-FRBA-SSL-LABS/laboratorios`.
2. Publicar la rama `main` de este monorepo.
3. Probar un cambio aislado en cada carpeta y confirmar que solo se ejecute el
   laboratorio correspondiente.
4. Actualizar los assignments para usar el monorepo como repositorio inicial.
5. Mantener los repositorios base anteriores en modo solo lectura durante un
   período de transición; archivarlos recién después de validar el nuevo flujo.

GitHub Classroom copia el repositorio completo para cada assignment. Si se
quiere que cada estudiante vea solamente un laboratorio, la alternativa es
mantener repositorios plantilla livianos que extraigan o sincronicen una carpeta
del monorepo. Si se acepta que vean todo el material, el monorepo puede usarse
directamente y el CI seguirá ejecutando solo las carpetas modificadas.
