{ config, pkgs, lib, inputs, ... }: # Pass inputs as a whole

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

    # Terminal Emulator
    kitty
    gnome-screenshot # For PrintScreen hotkey
    gromit-mpx # For screen drawing/annotation
    bibata-cursors # For custom cursor theme
  ];

  # GNOME extensions and keyboard layout settings
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "appindicator@ubuntu.com"
        "blur-my-shell@aunetx"
        "vitals@corecoding.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
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

    # GNOME Accessibility Magnifier (Zoom) settings
    "org/gnome/desktop/a11y/magnifier" = {
      mag-factor = 2.0; # Default zoom level
      mouse-tracking-mode = "edge"; # Zoom follows mouse cursor only at screen edges
      scroll-wheel-zoom = true; # Enable zoom with scroll wheel
    };
    "org/gnome/desktop/interface" = {
      cursor-theme = "Bibata-Modern-Ice";
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

  # Declarative Kitty configuration
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 11.0;
    };
    settings = {
      # Cursor settings
      "cursor_shape" = "beam";
      "cursor_trail" = "1";

      # Padding (why weird value? consistency with foot)
      "window_margin_width" = "21.75";

      # No close confirmation
      "confirm_os_window_close" = "0";

      # Use fish shell
      "shell" = "fish";

      # Copy
      "map ctrl+c" = "copy_or_interrupt";

      # Search
      "map ctrl+f" = "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
      "map kitty_mod+f" = "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";

      # Scroll & Zoom
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

  # Ensure starship is enabled for the user
  programs.starship.enable = true;
}
