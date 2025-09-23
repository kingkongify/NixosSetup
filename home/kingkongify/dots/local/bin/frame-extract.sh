#!/bin/bash

# === CONFIG ===
VIDEO="$1"
OUTDIR="$HOME/.local/bin/mpvpywal"
FRAME_PATH="$OUTDIR/mpvshot.jpg"
PYWALSET="$HOME/.local/bin/pywal-from-frame.sh"

# === Checks ===
if [[ -z "$VIDEO" || ! -f "$VIDEO" ]]; then
    echo "No valid video path provided!"
    exit 1
fi

# Get video duration
DURATION=$(ffprobe -v error -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 "$VIDEO")

# Generate random time (up to duration - 1s to avoid EOF issues)
RANDOM_TIME=$(awk -v max="$DURATION" 'BEGIN { srand(); print int(rand()*(max-1)) }')

# Prep output dir
mkdir -p "$OUTDIR"
rm -f "$FRAME_PATH"

# Extract frame
if ffmpeg -y -ss "$RANDOM_TIME" -i "$VIDEO" -frames:v 1 "$FRAME_PATH" >/dev/null 2>&1; then
    echo "Frame saved to: $FRAME_PATH"
else
    echo "Frame extraction failed"
    exit 2
fi

# Run pywal-from-frame.sh
if [[ -x "$PYWALSET" ]]; then
    "$PYWALSET"
else
    echo "Frame extracted, but pywal script missing or not executable: $PYWALSET"
fi
