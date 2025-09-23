#!/bin/bash

# Define target repo folder
DOTFILES_DIR=~/dotfiles

# Make sure it exists
mkdir -p "$DOTFILES_DIR"

echo "📦 Syncing dotfiles to $DOTFILES_DIR ..."

# Copy scripts
mkdir -p "$DOTFILES_DIR/local/bin"
cp -ru ~/.local/bin/* "$DOTFILES_DIR/local/bin/"

# Copy config folders
CONFIGS=(hypr thunar kitty waybar fastfetch cava)
for config in "${CONFIGS[@]}"; do
    mkdir -p "$DOTFILES_DIR/config/$config"
    cp -ru ~/.config/$config/* "$DOTFILES_DIR/config/$config/"
done

# Copy starship script
mkdir -p "$DOTFILES_DIR/config"
cp -u ~/.config/starship-pywal-gen.sh "$DOTFILES_DIR/config/"

# Copy zshrc
cp -u ~/.zshrc "$DOTFILES_DIR/"

# Git stuff
cd "$DOTFILES_DIR" || exit
git add .
git commit -m "📦 Auto backup on $(date '+%Y-%m-%d %H:%M:%S')"
git push

echo "✅ Dotfiles synced and pushed to GitHub!"
