{ config, pkgs, ... }:

{
  networking = {
    hostName = "nixos-laptop";
    networkmanager.enable = true;
  };
}
