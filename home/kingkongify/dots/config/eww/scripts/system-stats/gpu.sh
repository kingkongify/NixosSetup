#!/usr/bin/env bash
set -euo pipefail

# Grab GPU usage from radeontop (first sample, fast)
usage=$(radeontop -d - -l 1 2>/dev/null | grep -oP 'gpu \K\d+' | head -1)

# Fallback to 0 if radeontop didn’t return anything
echo -n "${usage:-0}"
