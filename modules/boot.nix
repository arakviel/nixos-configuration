{ config, pkgs, ... }:

{
  # Bootloader configurations
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
