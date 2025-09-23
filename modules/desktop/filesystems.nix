{ config, pkgs, ... }:

{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/66a7d181-016d-4f71-b6f9-4c237359623b";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" ];
    };
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/25B1-AB50";
      fsType = "vfat";
    };
    "/disk" = {
      device = "/dev/disk/by-uuid/7ea24411-3398-4d90-8dbe-a256ce6dd041";
      fsType = "ext4";
    };
  };
}
