#!/usr/bin/env bash
# bin/_lib.sh

set -euo pipefail

BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$BIN_DIR/.." && pwd)"
if [[ -z "${MISE_BIN:-}" ]]; then
  MISE_BIN="$(command -v mise || true)"
  MISE_BIN="${MISE_BIN:-${HOME}/.local/bin/mise}"
fi
export BIN_DIR ROOT_DIR
cd "$ROOT_DIR"

if [[ ! -x "$MISE_BIN" ]]; then
  echo "mise was not found at $MISE_BIN" >&2
  exit 1
fi

run_bundle() {
  "$MISE_BIN" exec -- bundle exec "$@"
}
