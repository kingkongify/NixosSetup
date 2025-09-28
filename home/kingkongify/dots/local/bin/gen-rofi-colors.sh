#!/usr/bin/env bash


# Paths
WAL_COLORS="$HOME/.cache/wal/colors.json"
ROFI_COLORS="$HOME/.config/rofi/colors.rasi"

### --- Generate Rofi Colors --- ###
jq -r '
  .colors | "
* {
    primary: \(.color2);
    primary-fixed: \(.color6);
    primary-fixed-dim: \(.color2);
    on-primary: \(.color0);
    on-primary-fixed: \(.color0);
    on-primary-fixed-variant: \(.color0);
    primary-container: \(.color6);
    on-primary-container: \(.color0);
    secondary: \(.color4);
    secondary-fixed: \(.color5);
    secondary-fixed-dim: \(.color4);
    on-secondary: \(.color0);
    on-secondary-fixed: \(.color0);
    on-secondary-fixed-variant: \(.color0);
    secondary-container: \(.color5);
    on-secondary-container: \(.color0);
    tertiary: \(.color3);
    tertiary-fixed: \(.color6);
    tertiary-fixed-dim: \(.color3);
    on-tertiary: \(.color0);
    on-tertiary-fixed: \(.color0);
    on-tertiary-fixed-variant: \(.color0);
    tertiary-container: \(.color6);
    on-tertiary-container: \(.color0);
    error: \(.color1);
    on-error: \(.color15);
    error-container: \(.color1);
    on-error-container: \(.color15);
    surface: \(.color0);
    on-surface: \(.color15);
    on-surface-variant: \(.color7);
    outline: \(.color8);
    outline-variant: \(.color7);
    shadow: #000000;
    scrim: #000000;
    inverse-surface: \(.color15);
    inverse-on-surface: \(.color0);
    inverse-primary: \(.color4);
    surface-dim: \(.color0);
    surface-bright: \(.color7);
    surface-container-lowest: \(.color0);
    surface-container-low: \(.color0);
    surface-container: \(.color0);
    surface-container-high: \(.color7);
    surface-container-highest: \(.color15);
}
" ' "$WAL_COLORS" > "$ROFI_COLORS"



notify-send "Pywal Colorset" "Rofi theme updated!"
