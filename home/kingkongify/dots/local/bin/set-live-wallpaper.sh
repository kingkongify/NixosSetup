#!/bin/bash

# === CONFIG ===
WALLPAPER_DIR="$HOME/Videos/Wallpapers/Live"
MPVPYWAL_DIR="$HOME/.local/bin/mpvpywal"
FRAME_PATH="$MPVPYWAL_DIR/mpvshot.jpg"
EXTRACT_SCRIPT="$HOME/.local/bin/frame-extract.sh"

mkdir -p "$MPVPYWAL_DIR"

# === Use argument if passed ===
if [ -n "$1" ] && [ -f "$1" ]; then
    VIDEO="$1"
else
    # === Get all video files ===
    mapfile -t VIDEOS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.mp4" -o -iname "*.webm" \))

    if [ ${#VIDEOS[@]} -eq 0 ]; then
        echo "❌ No videos found in $WALLPAPER_DIR"
        exit 1
    fi

    echo "Choose Your Live Wallpaper:"
    for i in "${!VIDEOS[@]}"; do
        echo "  [$i] $(basename "${VIDEOS[$i]}")"
    done

    read -rp "Enter number: " CHOICE

    if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 0 ] || [ "$CHOICE" -ge "${#VIDEOS[@]}" ]; then
        echo "❌ Invalid choice."
        exit 1
    fi

    VIDEO="${VIDEOS[$CHOICE]}"
fi

echo "Selected: $(basename "$VIDEO")"

# === Kill any existing mpvpaper instance ===
pkill -x mpvpaper 2>/dev/null

# === Start mpvpaper on HDMI-A-1 ===
mpvpaper -o "no-audio --loop --hwdec=vaapi --screenshot-template=$FRAME_PATH" HDMI-A-1 "$VIDEO" &

# === Extract frame ===
if [ -x "$EXTRACT_SCRIPT" ]; then
    "$EXTRACT_SCRIPT" "$VIDEO"
else
    echo "Frame extract script not found or not executable: $EXTRACT_SCRIPT"
fi

notify-send "LiveWal" "Theme & wallpaper set: $(basename "$VIDEO")"
