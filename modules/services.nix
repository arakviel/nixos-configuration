{ config, pkgs, ... }:

{
  # System-wide services configurations
  services.dbus.enable = true;
  services.printing.enable = true;
  services.saned.enable = true;
  services.udisks2.enable = true;
  security.polkit.enable = true;
  services.tlp.enable = false;
}
