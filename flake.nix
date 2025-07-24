{
  description = "Arakviel's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations.arakviel-pc = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
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

            systemd.services.clone-nixos-config = {
              description = "Clone NixOS configuration repository";
              wantedBy = [ "multi-user.target" ];
              after = [ "network-online.target" ];
              requires = [ "network-online.target" ];
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStart = ''
                  ${pkgs.git}/bin/git clone https://github.com/arakviel/nixos-configuration.git /mnt/etc/nixos
                '';
              };
            };
          })
        ];
      };
    };
}
