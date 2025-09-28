{ config, pkgs, lib, packages, nix-flatpak, ... }:
let
src = ./dots;
in
{
imports = [
nix-flatpak.homeManagerModules.nix-flatpak
 ];
home.username = "kingkongify";
home.homeDirectory = "/home/kingkongify";
home.stateVersion = "25.05";

# User packages (all the desktop/utility stuff)
home.packages = with pkgs; [
 (python3.withPackages (ps: with ps; [ colorthief pillow pip ]))
    ffmpeg
    pywal
    psmisc # killall, fuser, etc.
    procps # pkill, pgrep, top, uptime, etc.
    ] ++ (packages.userDesktop pkgs)
      ++ (packages.userUtilities pkgs)
      ++ (packages.userHyprland pkgs)
      ++ (packages.userDev pkgs)
      ++ (packages.fonts pkgs);

# User-level fonts (this should fix eww not seeing fonts)
fonts.fontconfig.enable = true;

# User-level flatpak configuration
services.flatpak = {
    enable = true;
    packages = [
# Core flatpak tools
"com.github.tchx84.Flatseal"
# Useful open-source apps
"org.onlyoffice.desktopeditors"
"org.freedesktop.Platform"
"com.usebottles.bottles"
# Proprietary apps
"com.spotify.Client"
"net.xmind.XMind"
"org.vinegarhq.Sober"
 ];
 };

 
nixpkgs.config.allowUnfree = true;
home.activation.copyDotfilesForce = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
 mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.dotfile_backups"
 # Folders/files to ignore during rsync
 IGNORE_LIST=(
 "config/eww/styles/_colors.scss"
 "local/bin/wallpapertool/mpvshot.jpg"
 )
 # Rsync exclude args
 EXCLUDE_ARGS=()
 for item in "''${IGNORE_LIST[@@]}"; do
 EXCLUDE_ARGS+=(--exclude="$item")
 done
 # Exceptions (files inside ignored dirs to still sync)
 EXCEPTIONS=(
 "local/bin/wallpapertool/colortransparency.json"
 )
 # Rsync filter for exceptions
 FILTER_ARGS=()
 for f in "''${EXCEPTIONS[@@]}"; do
 FILTER_ARGS+=(--include="$f" --exclude="*")
 done
 # Sync config folders
 for dir in eww hypr rofi waybar cava btop; do
${pkgs.rsync}/bin/rsync -a --delete \
 --backup --backup-dir="$HOME/.dotfile_backups" \
 "''${EXCLUDE_ARGS[@@]}" "''${FILTER_ARGS[@@]}" \
${toString src}/config/$dir/ "$HOME/.config/$dir/"
 done
 # Sync local/bin
${pkgs.rsync}/bin/rsync -a --delete \
 --backup --backup-dir="$HOME/.dotfile_backups" \
 "''${EXCLUDE_ARGS[@@]}" "''${FILTER_ARGS[@@]}" \
${toString src}/local/bin/ "$HOME/.local/bin/"
 # Fix ownership and permissions
 chown -R "$USER":"$(id -gn)" "$HOME/.config" "$HOME/.local/bin"
 chmod -R u+rwX,go+rX "$HOME/.config" "$HOME/.local/bin"
 # Make scripts executable
 find "$HOME/.local/bin" -type f \( -name "*.sh" -o -name "*.py" -o -name "*.pl" -o -executable \) -exec chmod +x {} +
 find "$HOME/.config/eww/scripts" -type f \( -name "*.sh" -o -name "*.py" -o -name "*.pl" -o -executable \) -exec chmod +x {} + 2>/dev/null || true
 # Patch shebangs
 find "$HOME/.local/bin" -type f -exec sed -i '1s|^#! */bin/bash|#!/usr/bin/env bash|' {} +
 # Single files with backups
 for f in starship.toml zshrc; do
 src_file=${toString src}/$f
 dst_file="$HOME/.config/starship.toml"
 if [ "$f" = "zshrc" ]; then
 dst_file="$HOME/.zshrc"
 fi
 if [ -f "$dst_file" ] && ! cmp -s "$src_file" "$dst_file"; then
 ts=$(date +%Y%m%d-%H%M%S)
 cp -a "$dst_file" "$HOME/.dotfile_backups/$(basename "$dst_file").$ts.bak"
 fi
 install -D -m 0644 "$src_file" "$dst_file"
 chmod u+rw "$dst_file"
 chown "$USER":"$(id -gn)" "$dst_file"
 done
'';
}