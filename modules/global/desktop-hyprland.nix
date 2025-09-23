{ config, pkgs, ... }:

{
  # Enable Hyprland session
  programs.hyprland.enable = true;
  programs.xwayland.enable = true;

  # Enable XDG Desktop Portals (required for Flatpak & Wayland apps)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };


  # Session environment vars for Wayland & Electron apps
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  # Display manager
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = false;
  };

  # Spawn the Polkit agent in your session
  services.dbus.packages = with pkgs; [
    hyprpolkitagent
  ];
}
