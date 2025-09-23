  { pkgs, ... }:
  
  {
  environment.systemPackages = with pkgs; [
    hypridle
    hyprlock
    hyprpicker
    hyprsunset
    hyprcursor
    hyprutils
    hyprlang
    hyprwayland-scanner
    aquamarine
    hyprgraphics
    hyprland-qtutils
    xdg-desktop-portal-hyprland
    hyprpolkitagent
    hyprland-qt-support
  ];
  }