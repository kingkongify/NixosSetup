#!/usr/bin/env bash

set -euo pipefail

# Prints only the current active app class using hyprctl
# Falls back gracefully if hyprctl/jq fails

get_active() {
  local json
  if ! json=$(hyprctl -j activewindow 2>/dev/null); then
    echo "No Active Window"
    return 0
  fi
  local cls
  cls=$(printf '%s' "$json" | jq -r '.class // "Desktop"' 2>/dev/null || echo "Desktop")
  echo "$cls"
}

get_active


