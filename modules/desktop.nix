{ config, pkgs, lib, ... }:

{
  # Desktop environment settings
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Keyboard layout settings for English, Ukrainian, and Russian
  services.xserver.xkb.layout = "us,ua,ru";
  services.xserver.xkb.options = "grp:super_space_toggle,compose:ralt";

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.vitals
    gnomeExtensions.blur-my-shell
    gnomeExtensions.user-themes
    qt5.qtwayland
    qt6.qtwayland
    wl-clipboard
  ];
}
