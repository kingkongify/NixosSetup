#!/usr/bin/env bash

set -euo pipefail

CMD="${1:-current}"
ARG="${2:-}"

# Returns the active workspace id (number)
active_workspace() {
  hyprctl -j activeworkspace 2>/dev/null | jq -r '.id' || echo 1
}

case "$CMD" in
  current)
    active_workspace
    ;;
  switch)
    if [[ -z "${ARG}" ]]; then
      echo "Usage: $0 switch <workspace>" >&2
      exit 1
    fi
    hyprctl dispatch workspace "${ARG}"
    ;;
  *)
    echo "Usage: $0 [current|switch <n>]" >&2
    exit 1
    ;;
esac

