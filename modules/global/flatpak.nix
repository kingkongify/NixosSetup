{ config, pkgs, ... }:

{
  # Install the flatpak binary & enable system service
  services.flatpak.enable = true;
}
