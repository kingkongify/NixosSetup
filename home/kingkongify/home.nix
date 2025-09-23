{ config, pkgs, lib, ... }:

let
  src = ./dots;
in
{
  home.username = "kingkongify";
  home.homeDirectory = "/home/kingkongify";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    (python311.withPackages (ps: with ps; [ colorthief pillow ]))
    ffmpeg
    pywal
    psmisc     # killall, fuser, etc.
    procps     # pkill, pgrep, top, uptime, etc.
  ];

  nixpkgs.config.allowUnfree = true;

home.activation.copyDotfilesForce = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
  mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.dotfile_backups"

  # backup + force copy for dotfiles
  for dir in eww hypr rofi waybar cava btop; do
    ${pkgs.rsync}/bin/rsync -a --delete \
      --backup --backup-dir="$HOME/.dotfile_backups" \
      ${toString src}/config/$dir/ "$HOME/.config/$dir/"
  done

  ${pkgs.rsync}/bin/rsync -a --delete \
    --backup --backup-dir="$HOME/.dotfile_backups" \
    ${toString src}/local/bin/ "$HOME/.local/bin/"

  # fix ownership and perms *before* editing
  chown -R "$USER":"$(id -gn)" "$HOME/.config" "$HOME/.local/bin"
  chmod -R u+rwX,go+rX "$HOME/.config" "$HOME/.local/bin"

  # now patch shebangs safely
  find "$HOME/.local/bin" -type f -exec sed -i '1s|^#! */bin/bash|#!/usr/bin/env bash|' {} +

  # single files with backups
  for f in starship.toml zshrc; do
    src_file=${toString src}/$f
    if [ "$f" = "starship.toml" ]; then
      dst_file="$HOME/.config/starship.toml"
    else
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
