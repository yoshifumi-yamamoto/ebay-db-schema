#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_PATH="types/database.types.ts"

if [ -f "$REPO_ROOT/.env" ]; then
  set -a
  # shellcheck disable=SC1091
  source "$REPO_ROOT/.env"
  set +a
fi

if ! command -v supabase >/dev/null 2>&1; then
  echo "Error: supabase CLI が見つかりません。" >&2
  exit 1
fi

if [ -z "${SUPABASE_PROJECT_REF:-}" ]; then
  echo "Error: SUPABASE_PROJECT_REF が設定されていません。" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT_PATH")"

echo "TypeScript 型を生成します: ${SUPABASE_PROJECT_REF}"

if ! supabase gen types typescript --project-id "$SUPABASE_PROJECT_REF" --schema public > "$OUTPUT_PATH"; then
  echo "Error: 型定義の生成に失敗しました。" >&2
  exit 1
fi

echo "型定義の生成が完了しました: ${OUTPUT_PATH}"
