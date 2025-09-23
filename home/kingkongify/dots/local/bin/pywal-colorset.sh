#!/bin/bash

# Paths
WAL_COLORS="$HOME/.cache/wal/colors.json"
ROFI_COLORS="$HOME/.config/rofi/colors.rasi"
DISCORD_THEME="$HOME/.var/app/dev.vencord.Vesktop/config/vesktop/themes/midnight.theme.css"
TEMP_THEME="$HOME/.var/app/dev.vencord.Vesktop/config/vesktop/themes/midnight/midnight.theme.tmp.css"

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


### --- Generate Discord Colors --- ###
jq -r '
  .colors | "
:root {
    --text-1: \(.color15);
    --text-2: \(.color7);
    --text-3: \(.color8);
    --text-4: \(.color2);
    --text-5: \(.color3);

    --bg-1: \(.color0);
    --bg-2: \(.color0);
    --bg-3: \(.color0);
    --bg-4: \(.color0);

    --hover: \(.color1)33;
    --active: \(.color2)55;
    --active-2: \(.color2)77;
    --message-hover: \(.color7)33;

    --accent-1: \(.color4);
    --accent-2: \(.color5);
    --accent-3: \(.color6);
    --accent-4: \(.color2);
    --accent-5: \(.color3);
    --accent-new: \(.color5);

    --online: \(.color2);
    --dnd: \(.color1);
    --idle: \(.color3);
    --streaming: \(.color6);
    --offline: \(.color8);

    --border-light: \(.color7);
    --border: \(.color8);
    --border-hover: \(.color15);
    --button-border: \(.color8);

    --red-1: \(.color1);
    --red-2: \(.color1);
    --red-3: \(.color1);
    --red-4: \(.color1);
    --red-5: \(.color1);

    --green-1: \(.color2);
    --green-2: \(.color2);
    --green-3: \(.color2);
    --green-4: \(.color2);
    --green-5: \(.color2);

    --blue-1: \(.color4);
    --blue-2: \(.color4);
    --blue-3: \(.color4);
    --blue-4: \(.color4);
    --blue-5: \(.color4);

    --yellow-1: \(.color3);
    --yellow-2: \(.color3);
    --yellow-3: \(.color3);
    --yellow-4: \(.color3);
    --yellow-5: \(.color3);

    --purple-1: \(.color6);
    --purple-2: \(.color6);
    --purple-3: \(.color6);
    --purple-4: \(.color6);
    --purple-5: \(.color6);
}
" ' "$WAL_COLORS" > "$TEMP_THEME"

# Replace only the :root block in Discord theme
awk '
    BEGIN {in_block=0}
    /^:root[[:space:]]*{/ {print; system("cat " ENVIRON["TEMP_THEME"]); in_block=1; next}
    in_block && /^}/ {in_block=0; next}
    !in_block {print}
' "$DISCORD_THEME" > "$DISCORD_THEME.tmp"

mv "$DISCORD_THEME.tmp" "$DISCORD_THEME"
rm "$TEMP_THEME"

notify-send "Pywal Colorset" "Rofi + Discord themes updated!"
