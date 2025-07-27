{ config, pkgs, lib, inputs, ... }:

{
  home.username = "arakviel";
  home.homeDirectory = "/home/arakviel";
  home.stateVersion = "25.05";

  # User packages
  home.packages = with pkgs; [
    # Browsers
    google-chrome
    firefox
    microsoft-edge

    # Communication
    telegram-desktop
    discord
    slack

    # Multimedia
    obs-studio

    # Productivity
    obsidian
    onlyoffice-bin

    # Security
    protonvpn-gui
    proton-pass

    # Utilities
    kitty
    gnome-screenshot
    gromit-mpx
    bibata-cursors
  ];

  # GNOME configuration
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "appindicator@ubuntu.com"
        "blur-my-shell@aunetx"
        "vitals@corecoding.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
      disable-user-extensions = false;
    };
    "org/gnome/desktop/input-sources" = {
      sources = with lib.hm.gvariant; [
        (mkTuple [ (mkString "xkb") (mkString "us") ])
        (mkTuple [ (mkString "xkb") (mkString "ua") ])
        (mkTuple [ (mkString "xkb") (mkString "ru") ])
      ];
      xkb-options = [ "grp:super_space_toggle" "compose:ralt" ];
    };
    "org/gnome/desktop/a11y/magnifier" = {
      mag-factor = 2.0;
      mouse-tracking-mode = "edge";
      scroll-wheel-zoom = true;
    };
    "org/gnome/desktop/interface" = {
      cursor-theme = "Bibata-Modern-Ice";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
  };

  # Programs
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
      credential.helper = "!gh auth git-credential";
      safe.directory = "*";
    };
  };

  # Terminal configuration
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 11.0;
    };
    settings = {
      "cursor_shape" = "beam";
      "cursor_trail" = "1";
      "window_margin_width" = "21.75";
      "confirm_os_window_close" = "0";
      "shell" = "fish";
      "map ctrl+c" = "copy_or_interrupt";
      "map ctrl+f" = "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
      "map kitty_mod+f" = "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
      "map page_up" = "scroll_page_up";
      "map page_down" = "scroll_page_down";
      "map ctrl+plus" = "change_font_size all +1";
      "map ctrl+equal" = "change_font_size all +1";
      "map ctrl+kp_add" = "change_font_size all +1";
      "map ctrl+minus" = "change_font_size all -1";
      "map ctrl+underscore" = "change_font_size all -1";
      "map ctrl+kp_subtract" = "change_font_size all -1";
      "map ctrl+0" = "change_font_size all 0";
      "map ctrl+kp_0" = "change_font_size all 0";
    };
  };

  programs.starship.enable = true;
}
