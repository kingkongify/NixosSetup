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

    ## Common module to enable flakes + nix-command
    nixSettingsModule = { ... }: {
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
    };
  in
  {
    ## System-level packages (only essential drivers and system services)
    packages = {
      systemCore     = pkgs: import ./packages/system-core.nix { inherit pkgs; };
      hyprlandSystem = pkgs: import ./packages/hyprland-system.nix { inherit pkgs; };
      fonts          = pkgs: import ./packages/fonts.nix { inherit pkgs; };
      
      ## User-level packages (for home-manager)
      userDesktop    = pkgs: import ./packages/user-desktop.nix { inherit pkgs; };
      userUtilities  = pkgs: import ./packages/user-utilities.nix { inherit pkgs; };
      userHyprland   = pkgs: import ./packages/user-hyprland.nix { inherit pkgs; };
      userDev        = pkgs: import ./packages/user-dev.nix { inherit pkgs; };
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
          ./modules/global/core.nix

          ## Desktop-specific modules
          ./modules/desktop/filesystems.nix
          ./modules/desktop/networking.nix
          ./modules/desktop/users.nix

          ## Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kingkongify = import ./home/kingkongify/home.nix;
            home-manager.extraSpecialArgs = { 
              inherit (self) packages; 
              inherit nix-flatpak;
            };
          }

          ## Enable flakes + nix-command globally
          nixSettingsModule
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
          ./modules/global/core.nix

          ## Laptop-specific modules
          ./modules/laptop/filesystems.nix
          ./modules/laptop/networking.nix
          ./modules/laptop/users.nix

          ## Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kingkongify = import ./home/kingkongify/home.nix;
            home-manager.extraSpecialArgs = { 
              inherit (self) packages; 
              inherit nix-flatpak;
            };
          }

          ## Enable flakes + nix-command globally
          nixSettingsModule
        ];

        specialArgs = { inherit (self) packages; };
      };
    };
  };
}