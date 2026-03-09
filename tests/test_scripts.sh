#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "[FAIL] $*" >&2
  exit 1
}

echo "[INFO] Running harness_skill script checks..."

test -d "$ROOT_DIR/scripts" || fail "missing scripts/ directory"

sh_files="$(find "$ROOT_DIR/scripts" -maxdepth 1 -type f -name '*.sh' -print)"
test -n "$sh_files" || fail "no scripts/*.sh found"

echo "[INFO] bash -n (syntax check) on scripts/*.sh"
while IFS= read -r file; do
  echo "  - $file"
  bash -n "$file" || fail "bash syntax error: $file"
done <<< "$sh_files"

echo "[INFO] Required top-level files"
test -f "$ROOT_DIR/skill.json" || fail "missing skill.json"
test -f "$ROOT_DIR/README.md" || fail "missing README.md"
test -f "$ROOT_DIR/CHANGELOG.md" || fail "missing CHANGELOG.md"

echo "[INFO] Required config files"
test -f "$ROOT_DIR/config/env.example.json" || fail "missing config/env.example.json"
test -f "$ROOT_DIR/config/project_structure.json" || fail "missing config/project_structure.json"

echo "[PASS] All checks passed."


