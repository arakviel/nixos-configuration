{ config, pkgs, ... }:

{
  # System-wide programs
  environment.systemPackages = with pkgs; [
    wget
    htop
    neofetch
    unzip
    zip
    gnupg
    usbutils
    pciutils
    lshw
    lm_sensors
    smartmontools
  ];
}
