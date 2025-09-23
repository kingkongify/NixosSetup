{ config, pkgs, ... }:

{
  # Home Manager release compatibility
  home.stateVersion = "25.05";

  # User packages (optional)
  home.packages = with pkgs; [
    # Add small user-only packages here, if needed
  ];

  # Flatpak user apps
  imports = [ ./flatpak-apps.nix ];

  # Dotfile deployment (specific subdirectories)
  home.file = {
    ".config/eww".source       = ./dots/.config/eww;
    ".config/hypr".source      = ./dots/.config/hypr;
    ".config/rofi".source      = ./dots/.config/rofi;
    ".config/waybar".source    = ./dots/.config/waybar;
    ".config/cava".source      = ./dots/.config/cava;
    ".config/btop".source      = ./dots/.config/btop;
    ".config/starship.toml".source = ./dots/.config/starship.toml;
    ".local/bin".source        = ./dots/.local/bin;
    ".zshrc".source            = ./dots/.zshrc;
  };

  # Allow unfree packages (needed for some Flatpaks)
  nixpkgs.config.allowUnfree = true;
}
