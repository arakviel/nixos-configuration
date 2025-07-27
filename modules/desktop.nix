{ config, pkgs, lib, ... }:

{
  # Desktop environment
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Keyboard layouts
  services.xserver.xkb.layout = "us,ua,ru";
  services.xserver.xkb.options = "grp:super_space_toggle,compose:ralt";

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-browser-connector
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.vitals
    gnomeExtensions.blur-my-shell
    gnomeExtensions.user-themes
    qt5.qtwayland
    qt6.qtwayland
    wl-clipboard
  ];

  # Exclude GNOME packages
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    evolution
    gnome-contacts
    gnome-maps
    yelp
    gnome-user-docs
    gnome-terminal
    gnome-tour
  ];
}
