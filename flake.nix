{
  description = "NixOS flake for desktop and laptop (unstable), with Home Manager + Flatpak";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=v0.6.0";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }:
  let
    system = "x86_64-linux";
  in
  {
    ## Reusable package sets
    packages = {
      core      = pkgs: import ./packages/core.nix { inherit pkgs; };
      system    = pkgs: import ./packages/system.nix { inherit pkgs; };
      desktop   = pkgs: import ./packages/desktop.nix { inherit pkgs; };
      utilities = pkgs: import ./packages/utilities.nix { inherit pkgs; };
      dev       = pkgs: import ./packages/dev.nix { inherit pkgs; };
      hyprland  = pkgs: import ./packages/pkgs-hyprland.nix { inherit pkgs; };
    };

    ## NixOS system configurations
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configurations/desktop/configuration.nix

          ## Global modules
          ./modules/global/bootloader.nix
          ./modules/global/locale-time.nix
          ./modules/global/sudo.nix
          ./modules/global/input-display.nix
          ./modules/global/hyprland.nix
          ./modules/global/flatpak.nix

          ## Desktop-specific modules
          ./modules/desktop/filesystems.nix
          ./modules/desktop/networking.nix
          ./modules/desktop/users.nix

          ## Home Manager integration
          home-manager.nixosModules.home-manager
        ];

        specialArgs = { inherit (self) packages; };
      };

      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configurations/laptop/configuration.nix

          ## Global modules
          ./modules/global/bootloader.nix
          ./modules/global/locale-time.nix
          ./modules/global/sudo.nix
          ./modules/global/input-display.nix
          ./modules/global/hyprland.nix
          ./modules/global/flatpak.nix

          ## Laptop-specific modules
          ./modules/laptop/filesystems.nix
          ./modules/laptop/networking.nix
          ./modules/laptop/users.nix

          ## Home Manager integration
          home-manager.nixosModules.home-manager
        ];

        specialArgs = { inherit (self) packages; };
      };
    };

    ## Home Manager user config (dotfiles + flatpak apps)
    homeConfigurations = {
      kingkongify = home-manager.lib.homeConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./home/kingkongify/home.nix
          ./home/kingkongify/flatpak-apps.nix
        ];
      };
    };
  };
}
