{ config, pkgs, ... }:

{
environment.systemPackages = with pkgs; [
  firefox
  obs-studio
  mcpelauncher-ui-qt
  gimp3-with-plugins
  vesktop
];

}
