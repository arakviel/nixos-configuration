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

  # Copy Microsoft fonts to user directory for OnlyOffice compatibility
  home.activation.copyFonts = config.lib.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/.local/share/fonts

    # Copy Times New Roman and Arial fonts
    if [ -d "/nix/store" ]; then
      $DRY_RUN_CMD find /nix/store -name "*Times_New_Roman*.ttf" -type f -exec cp {} $HOME/.local/share/fonts/ \; 2>/dev/null || true
      $DRY_RUN_CMD find /nix/store -name "*Arial*.ttf" -type f -exec cp {} $HOME/.local/share/fonts/ \; 2>/dev/null || true

      # Update font cache
      $DRY_RUN_CMD ${pkgs.fontconfig}/bin/fc-cache -fv $HOME/.local/share/fonts 2>/dev/null || true
    fi
  '';

  # GNOME configuration
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgscjounas.gmail.com"
        "blur-my-shell@aunetx"
        "Vitals@CoreCoding.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "clipboard-indicator@tudmotu.com"
        "weatherornot@somepaulo.github.io"
      ];
      disable-user-extensions = false;
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "microsoft-edge.desktop"
        "kitty.desktop"
        "org.telegram.desktop.desktop"
        "code.desktop"
        "phpstorm.desktop"
        "rider.desktop"
        "idea-ultimate.desktop"
        "datagrip.desktop"
        "com.obsproject.Studio.desktop"
        "onlyoffice-desktopeditors.desktop"
      ];
    };

    # Weather extension configuration (Ужгород)
    "org/gnome/shell/extensions/weatherornot" = {
      city = "Uzhhorod, Ukraine";
      coordinates = lib.hm.gvariant.mkTuple [
        (lib.hm.gvariant.mkDouble 48.6167)
        (lib.hm.gvariant.mkDouble 22.3)
      ];
      units = "metric";
      refresh-interval = 600;
    };

    # Dash to Dock configuration
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      dock-fixed = true;
      show-favorites = true;
      show-running = true;
      show-apps-at-top = false;
      click-action = "minimize";
      scroll-action = "cycle-windows";
      hot-keys = false;
      hotkeys-overlay = false;
      hotkeys-show-dock = false;
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
      gtk-theme = "Adwaita-dark";
      color-scheme = "prefer-dark";
    };

    # Enable fractional scaling options
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 0;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
      power-button-action = "nothing";
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

  # Default applications configuration
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "microsoft-edge.desktop";
      "x-scheme-handler/http" = "microsoft-edge.desktop";
      "x-scheme-handler/https" = "microsoft-edge.desktop";
      "x-scheme-handler/about" = "microsoft-edge.desktop";
      "x-scheme-handler/unknown" = "microsoft-edge.desktop";
    };
  };

  # Set default browser environment variable
  home.sessionVariables = {
    FONTCONFIG_PATH = "/etc/fonts:/run/current-system/sw/etc/fonts";
    BROWSER = "microsoft-edge";
  };
}
