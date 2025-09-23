{ config, pkgs, ... }:

{
  # --- Virtualization ---

  # VirtualBox host setup
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "kingkongify" ];


  # Podman (alternative to Docker, rootless)
  # virtualisation.podman.enable = true;
}
