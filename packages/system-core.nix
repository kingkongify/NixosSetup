# packages/system-core.nix - Only essential system drivers and services
{ pkgs, ... }:

[
  # Essential Graphics drivers (system-level)
  pkgs.mesa
  pkgs.vulkan-tools
  pkgs.amdvlk
  
  # Hardware firmware and drivers
  pkgs.linux-firmware
  
  # Bluetooth system components (not user tools)
  pkgs.bluez
  
  # Audio system components (not user applications)
  pkgs.pipewire
  pkgs.wireplumber
  
  # Essential system utilities
  pkgs.pciutils
  pkgs.usbutils
  pkgs.psmisc     # killall, fuser, etc.
  pkgs.procps     # pkill, pgrep, top, uptime, etc.
]


