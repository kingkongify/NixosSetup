#!/bin/bash
# Setup script for EWW config structure
# Target: ~/.config/eww/

BASE_DIR="$HOME/.config/eww"

# Define all directories
DIRS=(
  "$BASE_DIR/styles"
  "$BASE_DIR/widgets/left"
  "$BASE_DIR/widgets/middle"
  "$BASE_DIR/widgets/right"
  "$BASE_DIR/scripts"
  "$BASE_DIR/leftbar"
  "$BASE_DIR/midbar"
  "$BASE_DIR/rightbar"
  "$BASE_DIR/assets/icons/audio-icons"
  "$BASE_DIR/assets/icons/power"
  "$BASE_DIR/assets/fonts/Inter"
  "$BASE_DIR/assets/wallpapers/previews"
)

# Define all files
FILES=(
  "$BASE_DIR/eww.yuck"
  "$BASE_DIR/eww.scss"

  # Styles
  "$BASE_DIR/styles/_variables.scss"
  "$BASE_DIR/styles/_animations.scss"
  "$BASE_DIR/styles/_left.scss"
  "$BASE_DIR/styles/_middle.scss"
  "$BASE_DIR/styles/_right.scss"

  # Widgets - left
  "$BASE_DIR/widgets/left/arch-logo.yuck"
  "$BASE_DIR/widgets/left/workspaces.yuck"
  "$BASE_DIR/widgets/left/current-app.yuck"

  # Widgets - middle
  "$BASE_DIR/widgets/middle/clock.yuck"
  "$BASE_DIR/widgets/middle/quick-menu.yuck"
  "$BASE_DIR/widgets/middle/search.yuck"
  "$BASE_DIR/widgets/middle/power-options.yuck"
  "$BASE_DIR/widgets/middle/wallpaper-options.yuck"
  "$BASE_DIR/widgets/middle/productivity.yuck"
  "$BASE_DIR/widgets/middle/settings.yuck"
  "$BASE_DIR/widgets/middle/ai-llm.yuck"

  # Widgets - right
  "$BASE_DIR/widgets/right/system-monitor.yuck"
  "$BASE_DIR/widgets/right/audio-section.yuck"
  "$BASE_DIR/widgets/right/audio-visualizer.yuck"

  # Scripts
  "$BASE_DIR/scripts/workspaces.sh"
  "$BASE_DIR/scripts/current-app.sh"
  "$BASE_DIR/scripts/system-stats.sh"
  "$BASE_DIR/scripts/audio.sh"
  "$BASE_DIR/scripts/power.sh"
  "$BASE_DIR/scripts/wallpaper.sh"
  "$BASE_DIR/scripts/search.sh"

  # Leftbar
  "$BASE_DIR/leftbar/leftbar.yuck"
  "$BASE_DIR/leftbar/arch-button.yuck"
  "$BASE_DIR/leftbar/workspace-switcher.yuck"
  "$BASE_DIR/leftbar/active-window.yuck"

  # Midbar
  "$BASE_DIR/midbar/midbar.yuck"
  "$BASE_DIR/midbar/time-display.yuck"
  "$BASE_DIR/midbar/hover-menu.yuck"
  "$BASE_DIR/midbar/search-overlay.yuck"
  "$BASE_DIR/midbar/power-menu.yuck"
  "$BASE_DIR/midbar/wallpaper-menu.yuck"
  "$BASE_DIR/midbar/productivity-menu.yuck"
  "$BASE_DIR/midbar/settings-menu.yuck"
  "$BASE_DIR/midbar/ai-chat.yuck"

  # Rightbar
  "$BASE_DIR/rightbar/rightbar.yuck"
  "$BASE_DIR/rightbar/cpu-widget.yuck"
  "$BASE_DIR/rightbar/ram-widget.yuck"
  "$BASE_DIR/rightbar/audio-widget.yuck"
  "$BASE_DIR/rightbar/audio-expanded.yuck"
  "$BASE_DIR/rightbar/visualizer.yuck"

  # Assets/icons placeholders
  "$BASE_DIR/assets/icons/arch-logo.svg"
  "$BASE_DIR/assets/icons/cpu-icon.svg"
  "$BASE_DIR/assets/icons/ram-icon.svg"
  "$BASE_DIR/assets/icons/audio-icons/speaker.svg"
  "$BASE_DIR/assets/icons/audio-icons/microphone.svg"
  "$BASE_DIR/assets/icons/audio-icons/play.svg"
  "$BASE_DIR/assets/icons/audio-icons/pause.svg"
  "$BASE_DIR/assets/icons/audio-icons/next.svg"
  "$BASE_DIR/assets/icons/audio-icons/prev.svg"
  "$BASE_DIR/assets/icons/power/shutdown.svg"
  "$BASE_DIR/assets/icons/power/restart.svg"
  "$BASE_DIR/assets/icons/power/sleep.svg"
)

# Create directories
echo "Creating directories..."
for dir in "${DIRS[@]}"; do
  mkdir -p "$dir"
done

# Create empty files
echo "Creating placeholder files..."
for file in "${FILES[@]}"; do
  touch "$file"
done

echo "✅ EWW config structure created at $BASE_DIR"
