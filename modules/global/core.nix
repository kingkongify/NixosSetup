{ config, lib, pkgs, ... }:

with lib;

{
  # Enable firmware for devices that need redistributable blobs
  hardware.enableRedistributableFirmware = true;

  # --- GPU / Graphics (AMD / Mesa / Vulkan) ---
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ mesa vulkan-tools libva libva-utils ];
    extraPackages32 = with pkgs; [ driversi686Linux.mesa driversi686Linux.vulkan-tools ];
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
    pulse.enable = true;
    jack.enable = true;
  };

  # Optional system-wide packages
  environment.systemPackages = with pkgs; [
    wireplumber
  ];

  # --- Power management ---
  services.upower.enable = false;
}
