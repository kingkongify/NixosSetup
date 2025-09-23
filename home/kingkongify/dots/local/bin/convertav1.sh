#!/usr/bin/env bash


# === CONFIG ===
INPUT_DIR="$HOME/Videos/Wallpapers/Live"
OUTPUT_DIR="$HOME/Videos/Wallpapers/8bit"

mkdir -p "$OUTPUT_DIR"

echo "🎞️ Converting videos to 8-bit H.264..."

shopt -s nullglob
for file in "$INPUT_DIR"/*.{mp4,webm,mkv}; do
    filename=$(basename "$file")
    output_file="$OUTPUT_DIR/${filename%.*}_8bit.mp4"

    if [[ -f "$output_file" ]]; then
        echo "✅ Skipping already converted: $filename"
        continue
    fi

    echo "🔄 Converting: $filename → $(basename "$output_file")"
    ffmpeg -y -i "$file" \
        -c:v libx264 -pix_fmt yuv420p -preset fast -crf 23 \
        -an "$output_file"
    
    echo "✔️ Done: $filename"
done

echo "🏁 All conversions finished!"
