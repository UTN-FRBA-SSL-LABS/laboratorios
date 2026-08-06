# Grading y calificaciones

El grading local y el de GitHub Actions usan el mismo comando:

```bash
make grade LAB=lab-flex
```

El resultado se muestra en la terminal y también se guarda en:

- `calificaciones/lab-flex.log`: salida completa de los checks.
- `calificaciones/lab-flex.json`: nota y metadatos listos para automatización.
- `calificaciones/lab-flex.md`: resumen legible de la nota.

La carpeta `calificaciones/` está ignorada por Git para evitar que una
verificación local genere commits accidentales.

En `lab-github`, algunos checks consultan pull requests y reviews. Si `gh` no
está autenticado localmente, el JSON usa `complete: false` y refleja solamente
los puntos verificables. En GitHub Actions esos checks se ejecutan con el token
de lectura del repositorio y la nota queda completa.

Estos archivos locales son solo una ayuda para el estudiante. La nota oficial
se vuelve a generar desde cero después de cada push y se publica como artefacto;
no existe un archivo de nota versionado que el estudiante pueda editar.

## Salida de GitHub Actions

Ante cada push, el workflow detecta qué carpetas cambiaron y ejecuta solamente
esos laboratorios. Antes de calificar, repone desde el repositorio docente los
archivos de infraestructura que hayan sido modificados. Un push que requiere
restauración genera un commit correctivo y luego califica los cambios válidos
del laboratorio sobre ese commit. Si el push solo modificó infraestructura, no
hay ningún laboratorio que calificar. La nota queda disponible de tres maneras:

1. En el **Job summary**, como tabla legible desde la ejecución del workflow.
2. En el artefacto `calificacion-<laboratorio>`, con Markdown, JSON y log.
3. En el artefacto `calificaciones`, con un único `calificaciones.json` que
   reúne todas las notas producidas por ese push.

Ejemplo de registro:

```json
{
  "schema_version": 1,
  "lab": "lab-flex",
  "score": 85,
  "max_score": 100,
  "minimum_score": 60,
  "passed": true,
  "complete": true,
  "status": "aprobado",
  "repository": "UTN-FRBA-SSL-LABS/laboratorios-alumno",
  "commit_sha": "abc123...",
  "ref": "main",
  "actor": "usuario-github",
  "run_id": "123456789",
  "run_attempt": "1",
  "workflow": "Grading de laboratorios",
  "grader_repository": "UTN-FRBA-SSL-LABS/laboratorios",
  "grader_commit_sha": "def456...",
  "generated_at": "2026-08-06T18:00:00Z"
}
```

## Consumo desde una planilla

La automatización debe consultar solo ejecuciones de la rama `main` del workflow
`Grading de laboratorios`. Puede consultar los artefactos con la API de
GitHub, localizar el artefacto más reciente llamado `calificaciones`, descargar
el ZIP y leer `calificaciones.json`. Conviene guardar en la planilla la clave
compuesta por `repository + lab + commit_sha` para que el proceso sea idempotente
y no duplique notas al ejecutarse más de una vez.

Los artefactos se conservan 30 días. La planilla debe ingerirlos periódicamente;
la fuente histórica permanente será la propia planilla. Para una segunda fase,
el job `consolidar-notas` puede enviar el mismo JSON directamente a un Apps
Script o webhook autenticado, sin cambiar el formato.

Los runners estándar son gratuitos en repositorios públicos, pero el
almacenamiento de artefactos sí forma parte de la cuota de la organización. La
retención corta y el tamaño reducido de estos JSON y logs limitan ese consumo.
La política vigente está documentada en
[GitHub Actions billing](https://docs.github.com/en/billing/concepts/product-billing/github-actions).
