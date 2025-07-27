{ config, pkgs, ... }:

{
  # System services
  services.dbus.enable = true;
  services.printing.enable = true;
  services.saned.enable = true;
  services.udisks2.enable = true;
  security.polkit.enable = true;
  services.tlp.enable = false;

  # Bluetooth
  services.blueman.enable = true;
}
