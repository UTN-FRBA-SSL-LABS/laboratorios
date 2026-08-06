# Calificaciones

El grading local y el de GitHub Actions usan el mismo comando:

```bash
make grade LAB=lab-flex
```

El resultado se muestra en la terminal y también se guarda en:

- `calificaciones/lab-flex.log`: salida completa de los checks.
- `calificaciones/lab-flex.json`: nota y metadatos listos para automatización.

La carpeta `calificaciones/` está ignorada por Git para evitar que una
verificación local genere commits accidentales.

En `lab-github`, algunos checks consultan pull requests y reviews. Si `gh` no
está autenticado localmente, el JSON usa `complete: false` y refleja solamente
los puntos verificables. En GitHub Actions esos checks se ejecutan con el token
de lectura del repositorio y la nota queda completa.

## Salida de GitHub Actions

Ante cada push, el workflow detecta qué carpetas cambiaron y ejecuta solamente
esos laboratorios. La nota queda disponible de tres maneras:

1. En el **Job summary**, como tabla legible desde la ejecución del workflow.
2. En el artefacto `calificacion-<laboratorio>`, con el JSON y el log de ese lab.
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
  "generated_at": "2026-08-06T18:00:00Z"
}
```

## Consumo desde una planilla

La automatización puede consultar los artefactos del repositorio con la API de
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
