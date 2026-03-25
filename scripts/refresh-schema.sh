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

"$SCRIPT_DIR/pull-schema.sh"
"$SCRIPT_DIR/gen-types.sh"

echo "スキーマと型定義の更新が完了しました。"
echo "次に docs/business-rules.md、docs/tables.md、docs/relationships.md、docs/deletion-candidates.md、docs/er-notes.md を見直してください。"
