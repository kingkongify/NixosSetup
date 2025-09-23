{ config, pkgs, packages, inputs, ... }:

{
  # Import hardware config (machine-specific)
  imports = [
    ./hardware-configuration.nix

    # Modules
    ../../modules/desktop/filesystems.nix
    ../../modules/desktop/networking.nix
    ../../modules/desktop/users.nix
    ../../modules/global/bootloader.nix
    ../../modules/global/locale-time.nix
    ../../modules/global/sudo.nix
    ../../modules/global/input-display.nix
    ../../modules/global/hyprland.nix
    ../../modules/global/flatpak.nix
  ];

  # System state version
  system.stateVersion = "25.05";

  ## System-wide packages
  environment.systemPackages = with pkgs; [
    # Core packages
  ] ++ (packages.core pkgs)
    ++ (packages.system pkgs)
    ++ (packages.desktop pkgs)
    ++ (packages.utilities pkgs)
    ++ (packages.hyprland pkgs)
    ++ (packages.dev pkgs)
    ++ (packages.flatpak pkgs); # your new pkgs-flatpak.nix

}
