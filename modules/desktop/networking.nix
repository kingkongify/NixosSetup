{ config, pkgs, ... }:

{
  networking = {
    hostName = "nixos-desktop";
    networkmanager.enable = true;
  };
}
