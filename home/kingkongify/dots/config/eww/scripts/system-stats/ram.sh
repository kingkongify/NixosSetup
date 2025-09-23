#!/usr/bin/env bash
set -euo pipefail

mem_total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
mem_available=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
mem_used=$(( mem_total - mem_available ))
echo -n $(( 100 * mem_used / mem_total ))
