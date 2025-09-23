# modules/global/core.nix
{ config, lib, pkgs, ... }:

with lib;

{
  # Enable firmware for devices that need redistributable blobs
  hardware.enableRedistributableFirmware = true;

  # --- GPU / Graphics ---
  hardware.opengl = {
    enable = true;
    # Provide mesa as extra packages for userspace tooling if needed:
    extraPackages = with pkgs; [ mesa vulkan-tools ];
  };

  # --- Bluetooth ---
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # --- Audio (PipeWire stack) ---
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse = {
      enable = true;
    };
    jack = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    wireplumber
  ];

  # --- Power management ---
  services.upower.enable = false;
}
