{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Editors
    vscodium
    nil

    # Languages & Runtimes
    git
    python3
    nodejs
    gcc
    gnumake
    cmake
    pkg-config

    # Useful Dev Tools
    lazygit         # TUI git client
    sqlite          # lightweight DB for dev
    jq              # JSON manipulation
    ripgrep         # fast grep
    fd              # better find
    tmux            # terminal multiplexer
    direnv          # per-project envs (great with nix-direnv)
  ];
}
