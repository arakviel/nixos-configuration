{ config, lib, pkgs, ... }:

{
  imports = [
    # Core System Modules
    ./disko-config.nix
    ./system.nix
    ./boot.nix
    ./networking.nix
    ./services.nix
    ./hardware.nix

    # User and Desktop Environment
    ./users.nix
    ./desktop.nix
    ./fonts.nix

    # Development and Programs
    ./development.nix
    ./programs.nix
    ./docker-services.nix
  ];
}