#!/usr/bin/env bash
set -euo pipefail

APPLY=false
if [[ "${1:-}" == "--apply" ]]; then
  APPLY=true
  shift
fi

if (($# == 0)); then
  echo "Uso: $0 [--apply] OWNER/REPO [OWNER/REPO ...]" >&2
  exit 64
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "Se requiere GitHub CLI (gh)." >&2
  exit 69
fi

protection_payload() {
  cat <<'JSON'
{
  "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismissal_restrictions": {},
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "required_approving_review_count": 0,
    "require_last_push_approval": false,
    "bypass_pull_request_allowances": {
      "users": ["santiagoferreiros"],
      "teams": [],
      "apps": []
    }
  },
  "restrictions": null,
  "required_linear_history": false,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "block_creations": false,
  "required_conversation_resolution": false,
  "lock_branch": false,
  "allow_fork_syncing": true
}
JSON
}

for repository in "$@"; do
  if ! [[ "$repository" =~ ^[^/]+/[^/]+$ ]]; then
    echo "Repositorio inválido: $repository (se espera OWNER/REPO)" >&2
    exit 64
  fi

  if [[ "$APPLY" == "false" ]]; then
    echo "[simulación] Proteger main en $repository"
    continue
  fi

  echo "Protegiendo main en $repository..."
  protection_payload | gh api \
    --method PUT \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2026-03-10" \
    "repos/$repository/branches/main/protection" \
    --input - >/dev/null
  echo "Protección aplicada: $repository"
done
