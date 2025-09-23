{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #################################
    ## Hyprland Desktop Experience ##
    #################################
    rofi
    kitty
    waybar
    eww


    ######################
    ## Theming & Colors ##
    ######################
    pywal
    python311Packages.colorthief
    swww        # wallpaper daemon
    mpvpaper    # live wallpapers
    
    ###################################
    ## Screenshot / Screen Recording ##
    ###################################
    grim
    slurp
    wl-clipboard
    swappy

    ######################
    ## System Utilities ##
    ######################
    pavucontrol     # audio control GUI
    brightnessctl   # backlight control
    dunst           # notification daemon
    mpv

    ## File Management
    xfce.thunar     # graphical file manager
    ranger          # terminal file manager (ncurses)
    yazi            # modern TUI file manager
    p7zip
    unzip
    xz
    lrzip
    zstd

    ## CLI Productivity / Monitoring
    fastfetch
    neofetch
    htop
    btop
    lsof
    pciutils
    usbutils
    ranger
    eza
    bat
    yazi
    cava
  ];
}
