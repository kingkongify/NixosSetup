{ config, pkgs, ... }:

{
  services.flatpak.enable = true;

  # Declarative list of user Flatpak apps
  services.flatpak.packages = with pkgs; [

    # --- Important / core apps ---
    "com.github.tchx84.Flatseal"

    # --- Useful open-source apps ---
    "org.onlyoffice.desktopeditors"
    "org.freedesktop.Platform"
    "com.usebottles.bottles"

    # --- Proprietary / non-free apps ---
    "com.spotify.Client"
    "net.xmind.XMind"
    "org.vinegarhq.Sober"
  ];
}
