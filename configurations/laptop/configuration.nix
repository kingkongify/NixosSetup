{ config, pkgs, packages, inputs, ... }:

{
  # Import hardware config (machine-specific)
  imports = [
    ./hardware-configuration.nix

    # Modules
    ../../modules/laptop/filesystems.nix
    ../../modules/laptop/networking.nix
    ../../modules/laptop/users.nix
    ../../modules/global/virtualization.nix
    ../../modules/global/bootloader.nix
    ../../modules/global/locale-time.nix
    ../../modules/global/sudo.nix
    ../../modules/global/input-display.nix
    ../../modules/global/hyprland.nix
    ../../modules/global/flatpak.nix
  ];

  # System state version
  system.stateVersion = "25.05";

  # --- HOME MANAGER (apply user's home as part of system activation) ---
  # Ensure the home-manager module is included in your modules list (you already do).
  # Tell it to manage the "kingkongify" user and load the home.nix module from the flake.
  home-manager.users.kingkongify = {
    # Use the pkgs that NixOS provides in this evaluation
    pkgs = pkgs;

    # modules is a list of Home Manager modules (your home.nix is one)
    modules = [
      ../../home/kingkongify/home.nix
      ../../home/kingkongify/flatpak-apps.nix
    ];

    # optionally: set stateVersion if needed for Home Manager itself
    # stateVersion = "25.05";
  };

  ## System-wide packages
environment.systemPackages = concatLists [
  (if packages ? core then packages.core pkgs else [])
  (if packages ? desktop then packages.desktop pkgs else [])
  (if packages ? utilities then packages.utilities pkgs else [])
  (if packages ? hyprland then packages.hyprland pkgs else [])
  (if packages ? dev then packages.dev pkgs else [])
];

}
