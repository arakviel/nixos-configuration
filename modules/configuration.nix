{ config, lib, pkgs, ... }:

{
  imports = [
    # Core system modules
    ./system.nix
    ./boot.nix
    ./networking.nix
    ./services.nix
    ./hardware.nix

    # User and desktop environment
    ./users.nix
    ./desktop.nix
    ./fonts.nix

    # Development and programs
    ./development.nix
    ./shell.nix
    ./virtualization.nix
    ./docker-services.nix
  ];
}