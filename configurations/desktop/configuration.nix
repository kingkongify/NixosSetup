{ config, pkgs, packages, inputs, ... }:

{
  #Experimental
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Import hardware config (machine-specific)
  imports = [
    ./hardware-configuration.nix

    # Modules
    ../../modules/desktop/filesystems.nix
    ../../modules/desktop/networking.nix
    ../../modules/desktop/users.nix
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

  ## Enable flakes & nix-command globally
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  ## System-wide packages (ONLY system essentials)
  environment.systemPackages = with pkgs; [
    # Only essential system tools
    home-manager
  ] ++ (packages.systemCore pkgs)
    ++ (packages.hyprlandSystem pkgs)
    ++ (packages.fonts pkgs);

  # Enable system fonts (this is needed for font packages to work properly)
  fonts.enableDefaultPackages = true;
}