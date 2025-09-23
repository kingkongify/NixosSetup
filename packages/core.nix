# packages/core.nix
{ pkgs, ... }:

[
  # Graphics Related
  pkgs.mesa
  pkgs.vulkan-tools
  pkgs.amdvlk

  # System Related
  pkgs.home-manager
  
  # PipeWire & helpers (user-space)
  pkgs.pipewire
  pkgs.wireplumber

  # Bluetooth user tools
  pkgs.bluez
  pkgs.bluez-tools
  pkgs.bluez-alsa
]
