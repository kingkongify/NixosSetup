{ config, pkgs, ... }:

{
  users.users.kingkongify = {
    isNormalUser = true;
    description = "Main user";
    shell = pkgs.zsh;

    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
      "plugdev"
      "vboxusers"
    ];
  };

  users.users.root.initialPassword = "root";

  programs.zsh.enable = true;
}
