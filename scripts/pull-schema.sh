#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ -f "$REPO_ROOT/.env" ]; then
  set -a
  # shellcheck disable=SC1091
  source "$REPO_ROOT/.env"
  set +a
fi

# 初回は `supabase link --project-ref "$SUPABASE_PROJECT_REF"` が必要です。

if ! command -v supabase >/dev/null 2>&1; then
  echo "Error: supabase CLI が見つかりません。" >&2
  exit 1
fi

if [ -z "${SUPABASE_PROJECT_REF:-}" ]; then
  echo "Error: SUPABASE_PROJECT_REF が設定されていません。" >&2
  exit 1
fi

echo "Supabase schema を pull します: ${SUPABASE_PROJECT_REF}"

if ! supabase db pull; then
  echo "Error: supabase db pull に失敗しました。" >&2
  exit 1
fi

echo "Schema pull が完了しました。"
