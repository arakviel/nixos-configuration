{
  description = "Arakviel's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, disko, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations.arakviel-pc = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          ./disko-config.nix
          ./modules/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.arakviel = import ./modules/home.nix;
            system.stateVersion = "25.05";
          }
        ];
      };

      nixosConfigurations.installer = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ({ pkgs, ... }: {
            environment.systemPackages = with pkgs; [
              git
            ];
          })
        ];
      };
    };
}