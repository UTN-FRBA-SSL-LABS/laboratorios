# Restauración automática de infraestructura

Los repositorios de estudiantes son copias independientes. Ante cada push, el
workflow compara los archivos docentes con
`UTN-FRBA-SSL-LABS/laboratorios@main`.

## Archivos restaurados

El manifiesto `.grading-protected` es la única fuente de verdad. Actualmente
incluye:

- todo `.github/` y `scripts/`;
- el `Makefile`, `README.md` y `.gitignore` de la raíz;
- `.grading-protected` y `.grading-version`;
- `docs/GRADING.md` y este documento;
- todos los `labs/*/.gitignore` y `labs/*/test_local.sh`.

Los README ubicados dentro de `labs/` no se sincronizan: forman parte de la
entrega y pueden contener respuestas del estudiante.

`.grading-version` identifica la versión funcional de la infraestructura. Debe
incrementarse cuando un cambio sea incompatible con copias anteriores; el SHA
canónico sigue siendo el identificador exacto de cada ejecución.

Si encuentra una diferencia, repone la versión canónica, crea un commit con el
formato `chore: restaurar infraestructura docente (<sha>) [skip ci]` y lo
publica en la misma rama. La ejecución informa la corrección y el commit
canónico en su resumen, y continúa sobre el commit restaurado: los cambios
válidos del laboratorio se califican normalmente. Si el push solo alteró
infraestructura, no queda ningún laboratorio por evaluar.

Los fuentes, respuestas, enunciados y Makefiles internos de los ejercicios
siguen siendo editables. `@santiagoferreiros` queda exceptuado para poder
actualizar intencionalmente la infraestructura del repositorio canónico.

## Permiso usado por el workflow

El job de restauración declara `contents: write` para publicar el commit
correctivo; los jobs de grading conservan solamente lectura. El commit generado
con `GITHUB_TOKEN` no inicia otra ejecución, y el texto `[skip ci]` agrega una
segunda protección contra bucles. Una política organizacional o regla de rama
que impida escribir a `GITHUB_TOKEN` también impediría la autorrestauración.

## Límite de seguridad

La restauración dentro del mismo repositorio es una red de seguridad contra
cambios accidentales, no una frontera de seguridad. Una persona con escritura
puede modificar o borrar el propio workflow en el mismo push, o reducir sus
permisos, y evitar que se ejecute la restauración.

Si se necesita impedir también ese caso, el control debe vivir fuera del
repositorio del estudiante: por ejemplo, un workflow programado en el
repositorio docente o una GitHub App instalada por el owner que audite las
copias y reponga los archivos. Ese monitor conserva sus permisos aunque el
estudiante modifique su repositorio.

## Nota oficial

Incluso si la restauración fuera desactivada, el grading oficial descarga los
tests desde `UTN-FRBA-SSL-LABS/laboratorios@main`. Modificar `test_local.sh` en
la entrega no altera los tests usados para calcular la nota. La automatización
de la planilla debe aceptar solamente artefactos del workflow oficial y de la
rama `main`.
