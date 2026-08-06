# Protección de la infraestructura de grading

## Qué queda protegido

El archivo `.github/CODEOWNERS` asigna a `@santiagoferreiros` como responsable
de:

- `.github/`, incluido el workflow y el propio `CODEOWNERS`;
- `scripts/`, incluido el runner de grading;
- el `Makefile` raíz;
- `docs/GRADING.md` y este documento;
- todos los `labs/*/test_local.sh`.

Los fuentes, respuestas, enunciados y Makefiles que forman parte de los
ejercicios siguen siendo editables por los estudiantes.

## CODEOWNERS no alcanza por sí solo

Para que GitHub bloquee una modificación sin aprobación docente, `main` debe
tener una regla de protección que exija pull request y revisión de code owners.
La configuración recomendada es:

- rama protegida: `main`;
- requerir pull request antes de integrar;
- aprobaciones generales requeridas: `0`;
- requerir aprobación de code owners: sí;
- descartar aprobaciones al agregar commits: sí;
- bloquear force pushes y borrado de la rama: sí;
- aplicar la regla también a administradores: sí;
- permitir bypass únicamente a `@santiagoferreiros`.

Con esa combinación, un PR que solo cambia la solución puede integrarse sin
intervención docente. Un PR que toca infraestructura protegida queda esperando
la aprobación de `@santiagoferreiros`.

El script `scripts/protect-main.sh` permite aplicar esta configuración a uno o
varios repositorios. Por seguridad hace solamente una simulación salvo que se
indique `--apply`:

```bash
./scripts/protect-main.sh UTN-FRBA-SSL-LABS/repositorio-alumno
./scripts/protect-main.sh --apply UTN-FRBA-SSL-LABS/repositorio-alumno
```

Requiere `gh auth login` con permisos de administración sobre los repositorios.
Debe ejecutarse para cada repositorio creado por Classroom, o reemplazarse por
un ruleset organizacional si el plan de GitHub de la organización lo permite.

## Configuración obligatoria de GitHub Classroom

Al crear el assignment, dejá **desactivada** la opción **Grant students admin
access to their repository**. Los estudiantes necesitan acceso de escritura,
pero no administración: un administrador podría editar o eliminar las reglas de
protección. GitHub aclara además que cambiar esa opción luego no modifica de
forma retroactiva los repositorios que Classroom ya creó; los existentes deben
auditarse por separado.

## Defensa adicional del grading oficial

El workflow no usa el `test_local.sh` contenido en la entrega para calcular la
nota oficial. Descarga la versión de `main` desde
`UTN-FRBA-SSL-LABS/laboratorios` y la ejecuta contra los archivos enviados por
el estudiante. Por eso, editar un test en una rama personal no cambia el
resultado oficial.

La automatización de la planilla debe aceptar únicamente artefactos provenientes
de la rama `main` y del workflow `Grading de laboratorios`. Las ejecuciones de
ramas de trabajo sirven como devolución al estudiante, pero no como nota final.

## Por qué no se bloquean paths directamente

GitHub ofrece CODEOWNERS y protección de ramas en repositorios públicos. Los
push rulesets que restringen archivos por path están limitados a repositorios
privados o internos en los planes que los incluyen. Por eso la combinación
PR + CODEOWNERS es la alternativa nativa para repositorios públicos.

- [Documentación de CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [Documentación de ramas protegidas](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [Disponibilidad de rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)
- [Permisos de estudiantes en GitHub Classroom](https://docs.github.com/en/education/manage-coursework-with-github-classroom/teach-with-github-classroom/editing-an-assignment)
