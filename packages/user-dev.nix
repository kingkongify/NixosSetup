# packages/user-dev.nix - Development tools (for home-manager)
{ pkgs, ... }:

#NOTE : Python is already included in home.packages
[
  pkgs.vscodium
  pkgs.git
  pkgs.nodejs
  pkgs.gcc
  pkgs.gnumake
  pkgs.cmake
  pkgs.pkg-config
  pkgs.lazygit
  pkgs.sqlite
  pkgs.jq
  pkgs.ripgrep
  pkgs.fd
  pkgs.tmux
  pkgs.direnv
  pkgs.electron
]