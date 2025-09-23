.
├── configurations
│   ├── desktop
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── laptop
│       └── configuration.nix
├── flake.lock
├── flake.nix
├── home
│   └── kingkongify
│       ├── flatpak-apps.nix
│       ├── home.nix
│       └── dots
│           ├── starship.toml
│           ├── config
│           │   ├── cava
│           │   │   ├── cava.conf
│           │   │   ├── config
│           │   │   └── shaders
│           │   │       ├── bar_spectrum.frag
│           │   │       ├── northern_lights.frag
│           │   │       ├── pass_through.vert
│           │   │       ├── spectrogram.frag
│           │   │       └── winamp_line_style_spectrum.frag
│           │   ├── eww
│           │   │   ├── eww.scss
│           │   │   ├── eww.yuck
│           │   │   ├── leftbar
│           │   │   │   ├── active-window.yuck
│           │   │   │   ├── arch-button.yuck
│           │   │   │   ├── leftbar.yuck
│           │   │   │   └── workspace-switcher.yuck
│           │   │   ├── midbar
│           │   │   │   ├── midbar.yuck
│           │   │   │   └── time&date.yuck
│           │   │   ├── rightbar
│           │   │   │   ├── cpu-widget.yuck
│           │   │   │   ├── gpu-widget.yuck
│           │   │   │   ├── ram-widget.yuck
│           │   │   │   └── rightbar.yuck
│           │   │   ├── scripts
│           │   │   │   ├── arch-terminal-launch.sh
│           │   │   │   ├── audio.sh
│           │   │   │   ├── current-app.sh
│           │   │   │   ├── power.sh
│           │   │   │   ├── time.sh
│           │   │   │   ├── workspaces.sh
│           │   │   │   └── system-stats
│           │   │   │       ├── cpu.sh
│           │   │   │       ├── gpu.sh
│           │   │   │       └── ram.sh
│           │   │   └── styles
│           │   │       ├── _animations.scss
│           │   │       ├── _pywal.scss
│           │   │       └── _variables.scss
│           │   ├── fastfetch
│           │   │   ├── config.jsonc
│           │   │   └── Ascii
│           │   │       ├── arch-lines.txt
│           │   │       ├── arch-solid.txt
│           │   │       ├── johnxina.txt
│           │   │       ├── nixos_small.txt
│           │   │       ├── nixos.txt
│           │   │       ├── sigma.txt
│           │   │       ├── skull.txt
│           │   │       ├── toril.txt
│           │   │       ├── venom_small.txt
│           │   │       ├── venom.txt
│           │   │       └── windows.txt
│           │   ├── hypr
│           │   │   ├── default-hyprland.conf
│           │   │   ├── hyprland.conf
│           │   │   └── modules
│           │   │       ├── input.conf
│           │   │       ├── keybinds.conf
│           │   │       ├── look&feel.conf
│           │   │       ├── programs_and_applications.conf
│           │   │       ├── scripts.conf
│           │   │       ├── windowrules.conf
│           │   │       └── miscellaneous
│           │   │           ├── environment_variables.conf
│           │   │           ├── monitors.conf
│           │   │           └── permissions.conf
│           │   ├── kitty
│           │   │   └── kitty.conf
│           │   ├── rofi
│           │   │   ├── colors.rasi
│           │   │   └── config.rasi
│           │   └── waybar
│           │       ├── config
│           │       └── style.css
│           └── local
│               └── bin
│                   ├── 1.sh
│                   ├── connect.sh
│                   ├── convertav1.sh
│                   ├── dotfiles-sync.sh
│                   ├── frame-extract.sh
│                   ├── pywal-colorset.sh
│                   ├── pywal-from-frame.sh
│                   ├── set-live-wallpaper.sh
│                   └── mpvpywal
│                       ├── mpvshot.jpg
│                       └── mpvshot.jpg.jpg
├── modules
│   ├── desktop
│   │   ├── filesystems.nix
│   │   ├── networking.nix
│   │   └── users.nix
│   ├── global
│   │   ├── bootloader.nix
│   │   ├── core.nix
│   │   ├── flatpak.nix
│   │   ├── hyprland.nix
│   │   ├── input-display.nix
│   │   ├── locale-time.nix
│   │   ├── sudo.nix
│   │   └── virtualization.nix
│   └── laptop
│       ├── filesystems.nix
│       ├── networking.nix
│       └── users.nix
└── packages
    ├── core.nix
    ├── desktop.nix
    ├── dev.nix
    ├── pkgs-hyprland.nix
    └── utilities.nix
