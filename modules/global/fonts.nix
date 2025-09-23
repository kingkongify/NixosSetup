{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      # Nerd Fonts
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono

      # Noto (CJK + Emoji + Extras)
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      noto-fonts-extra

      # Source Han (CJK coverage)
      source-han-sans
      source-han-serif
    ];
  };
}
