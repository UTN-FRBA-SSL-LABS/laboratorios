#!/usr/bin/env bash
set -euo pipefail

SUBMISSION_ROOT="${SUBMISSION_ROOT:-$PWD}"
CANONICAL_ROOT="${CANONICAL_ROOT:-$SUBMISSION_ROOT/.grading}"
OWNER_ACTOR="${OWNER_ACTOR:-santiagoferreiros}"
RESTORE_PUSH="${RESTORE_PUSH:-false}"

write_output() {
  if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    echo "restored=$1" >> "$GITHUB_OUTPUT"
  fi
}

if [[ "${GITHUB_ACTOR:-}" == "$OWNER_ACTOR" ]]; then
  echo "El push pertenece al owner ($OWNER_ACTOR); no se restaura infraestructura."
  write_output false
  exit 0
fi

if [[ ! -d "$SUBMISSION_ROOT/.git" ]]; then
  echo "No se encontró un repositorio Git en $SUBMISSION_ROOT" >&2
  exit 66
fi

for path in .github scripts Makefile docs/GRADING.md docs/AUTORESTAURACION.md; do
  if [[ ! -e "$CANONICAL_ROOT/$path" ]]; then
    echo "Falta el archivo o directorio canónico: $path" >&2
    exit 66
  fi
done

for lab in "$CANONICAL_ROOT"/labs/*; do
  if [[ ! -f "$lab/test_local.sh" ]]; then
    echo "Falta el test canónico: ${lab#"$CANONICAL_ROOT/"}/test_local.sh" >&2
    exit 66
  fi
done

mkdir -p "$SUBMISSION_ROOT/.github" "$SUBMISSION_ROOT/scripts" "$SUBMISSION_ROOT/docs"
rsync -a --delete "$CANONICAL_ROOT/.github/" "$SUBMISSION_ROOT/.github/"
rsync -a --delete "$CANONICAL_ROOT/scripts/" "$SUBMISSION_ROOT/scripts/"
install -m 0644 "$CANONICAL_ROOT/Makefile" "$SUBMISSION_ROOT/Makefile"
install -m 0644 "$CANONICAL_ROOT/docs/GRADING.md" "$SUBMISSION_ROOT/docs/GRADING.md"
install -m 0644 "$CANONICAL_ROOT/docs/AUTORESTAURACION.md" "$SUBMISSION_ROOT/docs/AUTORESTAURACION.md"

protected_paths=(.github scripts Makefile docs/GRADING.md docs/AUTORESTAURACION.md)
for canonical_lab in "$CANONICAL_ROOT"/labs/*; do
  lab="$(basename "$canonical_lab")"
  destination="$SUBMISSION_ROOT/labs/$lab/test_local.sh"
  mkdir -p "$(dirname "$destination")"
  rsync -a "$canonical_lab/test_local.sh" "$destination"
  protected_paths+=("labs/$lab/test_local.sh")
done

git -C "$SUBMISSION_ROOT" add -A -- "${protected_paths[@]}"

if git -C "$SUBMISSION_ROOT" diff --cached --quiet; then
  echo "La infraestructura docente coincide con la versión canónica."
  write_output false
  exit 0
fi

echo "Se detectaron cambios en infraestructura docente; fueron restaurados:"
git -C "$SUBMISSION_ROOT" diff --cached --name-status
write_output true

if [[ "$RESTORE_PUSH" != "true" ]]; then
  echo "Restauración preparada localmente; no se creó ni publicó un commit."
  exit 0
fi

git -C "$SUBMISSION_ROOT" config user.name "github-actions[bot]"
git -C "$SUBMISSION_ROOT" config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git -C "$SUBMISSION_ROOT" commit -m "chore: restaurar infraestructura docente [skip ci]"
git -C "$SUBMISSION_ROOT" push origin "HEAD:${GITHUB_REF_NAME}"
