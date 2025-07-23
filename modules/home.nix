{ config, pkgs, lib, ... }:

{
  home.username = "arakviel";
  home.homeDirectory = "/home/arakviel";
  home.stateVersion = "25.05";

  # User-specific packages
  home.packages = with pkgs; [
    # Browsers
    google-chrome
    firefox
    microsoft-edge

    # Messengers
    telegram-desktop
    discord
    slack

    # Streaming and Multimedia
    obs-studio

    # Notes
    obsidian

    # VPN and Security
    protonvpn-gui
    proton-pass

    # Office Suite
    onlyoffice-bin
  ];

  # GNOME extensions and keyboard layout settings
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = with pkgs; [
        gnomeExtensions.dash-to-dock.extensionUuid
        gnomeExtensions.appindicator.extensionUuid
        gnomeExtensions.blur-my-shell.extensionUuid
        gnomeExtensions.user-themes.extensionUuid
      ];
    };
    "org/gnome/desktop/input-sources" = {
      sources = with lib.hm.gvariant; [
        (mkTuple [ (mkString "xkb") (mkString "us") ])
        (mkTuple [ (mkString "xkb") (mkString "ua") ])
        (mkTuple [ (mkString "xkb") (mkString "ru") ])
      ];
      xkb-options = [ "grp:super_space_toggle" "compose:ralt" ];
    };
  };

  # User-specific program configurations
  programs.fish = {
    enable = true;
    shellInit = ''
      starship init fish | source
    '';
  };

  programs.git = {
    enable = true;
    userName = "arakviel";
    userEmail = "insider.arakviel@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      color.ui = true;
      help.autocorrect = 20;
      credential.helper = "store";
      safe.directory = "*";
    };
  };
}