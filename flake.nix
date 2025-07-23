{
  description = "Arakviel's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-generators, disko, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations.arakviel-pc = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.arakviel = import ./modules/home.nix;
          }
          disko.nixosModules.default
          ({ config, pkgs, lib, ... }: {
            disko.devices = {
              disk.main = {
                device = "/dev/nvme0n1";
                type = "disk";
                content = {
                  type = "table";
                  format = "gpt";
                  partitions = [
                    {
                      name = "boot";
                      part-type = "primary";
                      start = "1MiB";
                      end = "1GiB";
                      fs-type = "fat32";
                      content = {
                        type = "filesystem";
                        format = "vfat";
                        mountpoint = "/boot";
                      };
                    }
                    {
                      name = "root";
                      part-type = "primary";
                      start = "1GiB";
                      end = "51GiB";
                      fs-type = "ext4";
                      content = {
                        type = "filesystem";
                        format = "ext4";
                        mountpoint = "/";
                      };
                    }
                    {
                      name = "swap";
                      part-type = "primary";
                      start = "51GiB";
                      end = "55GiB";
                      content = {
                        type = "swap";
                      };
                    }
                    {
                      name = "home";
                      part-type = "primary";
                      start = "55GiB";
                      end = "100%";
                      fs-type = "ext4";
                      content = {
                        type = "filesystem";
                        format = "ext4";
                        mountpoint = "/home";
                      };
                    }
                  ];
                };
              };
            };
          })
        ];
      };

      packages.${system}.arakviel-pc-iso = nixos-generators.nixosGenerate {
        inherit system;
        format = "install-iso";
        modules = [
          ./modules/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.arakviel = import ./modules/home.nix;
          }
          ({ config, pkgs, lib, ... }: {
            # Вимкнення networkmanager для ISO, щоб уникнути конфлікту
            networking.networkmanager.enable = true;
            networking.wireless.enable = lib.mkForce false; # Явно вимикаємо wireless
            # Додавання NetworkManager applet для зручності в ISO
            environment.systemPackages = with pkgs; [
              networkmanagerapplet
            ];
          })
        ];
      };
    };
}