# packages/user-utilities.nix - User desktop utilities (for home-manager)
{ pkgs, ... }:

[
  # Desktop environment components
  pkgs.rofi
  pkgs.waybar
  pkgs.eww
  pkgs.dunst
  
  # Terminal and shell
  pkgs.kitty
  
  # Wallpaper and theming
  pkgs.swww
  pkgs.mpvpaper
  pkgs.pywal
  pkgs.python311Packages.colorthief

  # Screenshot and clipboard
  pkgs.grim
  pkgs.slurp
  pkgs.wl-clipboard
  pkgs.swappy
  
  # Audio/video user controls
  pkgs.pavucontrol
  pkgs.brightnessctl
  pkgs.jamesdsp
  
  # File managers
  pkgs.xfce.thunar
  pkgs.ranger
  pkgs.yazi
  
  # Compression tools
  pkgs.p7zip
  pkgs.unzip
  pkgs.xz
  pkgs.lrzip
  pkgs.zstd
  
  # CLI utilities
  pkgs.fastfetch
  pkgs.neofetch
  pkgs.htop
  pkgs.btop
  pkgs.lsof
  pkgs.eza
  pkgs.bat
  pkgs.cava
  pkgs.libnotify
]

