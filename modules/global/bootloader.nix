{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages;
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev"; # for EFI-only systems
        efiInstallAsRemovable = true;
      };
      efi.efiSysMountPoint = "/boot/efi";
    };
  };
}
