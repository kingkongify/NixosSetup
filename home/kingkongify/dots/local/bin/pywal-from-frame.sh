#!/bin/bash

FRAME_ORIGINAL="$HOME/.local/bin/mpvpywal/mpvshot.jpg"
TEMP_FRAME="/tmp/wal_$(date +%s).jpg"

# Copy frame to unique file (forces Pywal to treat it as new)
cp "$FRAME_ORIGINAL" "$TEMP_FRAME"

# Generate Pywal theme from new image path
wal -i "$TEMP_FRAME" --vte -a 100

# Reload eww so it picks up new SCSS colors
eww reload

# Run combined Rofi + Discord colorset script
~/.local/bin/pywal-colorset.sh

# notify-send "Pywal" "Theme regenerated, eww + apps reloaded."
