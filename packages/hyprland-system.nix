# packages/hyprland-system.nix - Only system-level Hyprland components
{ pkgs, ... }:

[
  # Core Hyprland system components
  pkgs.hyprland
  pkgs.xdg-desktop-portal-hyprland
  pkgs.hyprpolkitagent
  
  # Essential Wayland/system integration
  pkgs.hyprwayland-scanner
  pkgs.aquamarine
  
  # System-level utilities that other packages depend on
  pkgs.hyprutils
  pkgs.hyprlang
]
