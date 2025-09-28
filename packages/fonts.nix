# packages/fonts.nix - Font packages
{ pkgs, ... }:

[
  # Nerd Fonts
  pkgs.nerd-fonts.iosevka
  pkgs.nerd-fonts.jetbrains-mono
  
  # Noto (CJK + Emoji + Extras)
  pkgs.noto-fonts
  pkgs.noto-fonts-cjk-sans
  pkgs.noto-fonts-cjk-serif
  pkgs.noto-fonts-emoji
  pkgs.noto-fonts-extra
  
  # Source Han (CJK coverage)
  pkgs.source-han-sans
  pkgs.source-han-serif
  
  # Other
  pkgs.iosevka
]