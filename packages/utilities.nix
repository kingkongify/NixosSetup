{ pkgs, ... }:

[
  pkgs.rofi
  pkgs.kitty
  pkgs.waybar
  pkgs.eww
  pkgs.pywal
  pkgs.python311Packages.colorthief
  pkgs.swww
  pkgs.mpvpaper


  pkgs.grim
  pkgs.slurp
  pkgs.wl-clipboard
  pkgs.swappy
  pkgs.pavucontrol
  pkgs.brightnessctl
  pkgs.dunst
  pkgs.mpv
  pkgs.jamesdsp
  pkgs.ffmpeg-full
  pkgs.psmisc     # killall, fuser, etc.
  pkgs.procps     # pkill, pgrep, top, uptime, etc.

  #file-manager
  pkgs.xfce.thunar
  pkgs.ranger
  pkgs.yazi
  pkgs.p7zip
  pkgs.unzip
  pkgs.xz
  pkgs.lrzip
  pkgs.zstd

  #cli
  pkgs.fastfetch
  pkgs.neofetch
  pkgs.htop
  pkgs.btop
  pkgs.lsof
  pkgs.pciutils
  pkgs.usbutils
  pkgs.eza
  pkgs.bat
  pkgs.cava
  pkgs.libnotify
]
