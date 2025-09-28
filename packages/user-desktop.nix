# packages/user-desktop.nix - User applications (for home-manager)
{ pkgs, ... }:

[
  # Browsers
  pkgs.firefox
  
  # Media and creative
  pkgs.obs-studio
  pkgs.gimp3-with-plugins
  pkgs.mpv
  
  # Communication
  pkgs.vesktop
  
  # Gaming
  pkgs.mcpelauncher-ui-qt
]

