{ config, pkgs, ... }:

{
  fileSystems = {
    "/" = {
      device = "";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" ];
    };
    "/boot/efi" = {
      device = "";
      fsType = "vfat";
    };
  };
}
