#!/usr/bin/env bash
# bin/_container.sh
# Shared commit-pure orchestration; never consume workspace Compose or .env inputs.
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

container_prepare() {
  [[ $# -le 1 ]] || { echo "Expected at most one committed git ref" >&2; exit 2; }
  DOCKER_BIN="${DOCKER_BIN:-docker}"
  VERIFY_SHA="$(git rev-parse --verify "${1:-HEAD}^{commit}")"
  VERIFY_CONTEXT="$(mktemp -d "${TMPDIR:-/tmp}/aat-verify.XXXXXXXX")"
  trap 'rm -rf -- "$VERIFY_CONTEXT"' EXIT
  git archive "$VERIFY_SHA" | tar -xf - -C "$VERIFY_CONTEXT"
  [[ -f "$VERIFY_CONTEXT/Dockerfile" && -f "$VERIFY_CONTEXT/compose.yaml" ]] || {
    echo "Selected commit lacks Dockerfile or compose.yaml" >&2; exit 1;
  }
  VERIFY_IMAGE="activeadmin-themes-verify:$VERIFY_SHA"
  export VERIFY_CONTEXT VERIFY_SHA VERIFY_IMAGE
  echo "Selected committed source: $VERIFY_SHA"
}

container_compose() {
  "$DOCKER_BIN" compose --env-file /dev/null --project-directory "$VERIFY_CONTEXT" \
    --project-name "aat-verify-$VERIFY_SHA" -f "$VERIFY_CONTEXT/compose.yaml" "$@"
}

container_identity() {
  local revision
  revision="$("$DOCKER_BIN" image inspect "$VERIFY_IMAGE" --format '{{index .Config.Labels "org.opencontainers.image.revision"}}')"
  [[ "$revision" == "$VERIFY_SHA" ]] || { echo "Image/source revision mismatch" >&2; exit 1; }
  VERIFY_IMAGE="$("$DOCKER_BIN" image inspect "$VERIFY_IMAGE" --format '{{.Id}}')"
  export VERIFY_IMAGE
  "$DOCKER_BIN" image inspect "$VERIFY_IMAGE" --format 'Image {{.Id}} architecture {{.Os}}/{{.Architecture}} source {{index .Config.Labels "org.opencontainers.image.revision"}}'
}
