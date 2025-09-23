{ pkgs, ... }:

with pkgs;

[
  # GPU / Vulkan / user tooling
  mesa
  vulkan-tools

  # AMD vendor ICD (optional; name may differ depending on nixpkgs version)
  amdvlk

  # PipeWire & helpers (user-space)
  pipewire
  pipewire-pulse
  wireplumber

  # Bluetooth user tools
  bluez
  bluez-utils
]
