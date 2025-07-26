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

  # Custom desktop entries for application categorization
  xdg.desktopEntries."google-chrome" = {
    name = "Google Chrome";
    exec = "${pkgs.google-chrome}/bin/google-chrome";
    icon = "google-chrome";
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
    comment = "Google Chrome web browser";
  };

  xdg.desktopEntries."firefox" = {
    name = "Firefox";
    exec = "${pkgs.firefox}/bin/firefox";
    icon = "firefox";
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
    comment = "Mozilla Firefox web browser";
  };

  xdg.desktopEntries."microsoft-edge" = {
    name = "Microsoft Edge";
    exec = "${pkgs.microsoft-edge}/bin/microsoft-edge";
    icon = "microsoft-edge";
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
    comment = "Microsoft Edge web browser";
  };

  xdg.desktopEntries."telegram-desktop" = {
    name = "Telegram Desktop";
    exec = "${pkgs.telegram-desktop}/bin/telegram-desktop";
    icon = "telegram";
    type = "Application";
    categories = [ "Network" "InstantMessaging" ];
    comment = "Official Telegram Desktop client";
  };

  xdg.desktopEntries."discord" = {
    name = "Discord";
    exec = "${pkgs.discord}/bin/discord";
    icon = "discord";
    type = "Application";
    categories = [ "Network" "InstantMessaging" ];
    comment = "Voice, video, and text chat for gamers";
  };

  xdg.desktopEntries."slack" = {
    name = "Slack";
    exec = "${pkgs.slack}/bin/slack";
    icon = "slack";
    type = "Application";
    categories = [ "Network" "InstantMessaging" ];
    comment = "Team communication platform";
  };

  xdg.desktopEntries."obs-studio" = {
    name = "OBS Studio";
    exec = "${pkgs.obs-studio}/bin/obs";
    icon = "obs-studio";
    type = "Application";
    categories = [ "AudioVideo" ];
    comment = "Free and open source software for video recording and live streaming";
  };

  xdg.desktopEntries."obsidian" = {
    name = "Obsidian";
    exec = "${pkgs.obsidian}/bin/obsidian";
    icon = "obsidian";
    type = "Application";
    categories = [ "Office" "TextEditor" ];
    comment = "A powerful knowledge base that works on local Markdown files";
  };

  xdg.desktopEntries."protonvpn-gui" = {
    name = "ProtonVPN";
    exec = "${pkgs.protonvpn-gui}/bin/protonvpn-gui";
    icon = "protonvpn";
    type = "Application";
    categories = [ "Network" "Security" ];
    comment = "ProtonVPN graphical user interface";
  };

  xdg.desktopEntries."proton-pass" = {
    name = "Proton Pass";
    exec = "${pkgs.proton-pass}/bin/proton-pass";
    icon = "proton-pass";
    type = "Application";
    categories = [ "Security" ];
    comment = "Proton Pass password manager";
  };

  xdg.desktopEntries."onlyoffice-bin" = {
    name = "ONLYOFFICE Desktop Editors";
    exec = "${pkgs.onlyoffice-bin}/bin/onlyoffice-desktopeditors";
    icon = "onlyoffice";
    type = "Application";
    categories = [ "Office" ];
    comment = "ONLYOFFICE Desktop Editors";
  };

  xdg.desktopEntries."kitty" = {
    name = "Kitty Terminal";
    exec = "${pkgs.kitty}/bin/kitty";
    icon = "kitty";
    type = "Application";
    categories = [ "System" "TerminalEmulator" ];
    comment = "A modern, feature-rich, fast, GPU based terminal emulator";
  };

  xdg.desktopEntries."gnome-tweaks" = {
    name = "GNOME Tweaks";
    exec = "${pkgs.gnome-tweaks}/bin/gnome-tweaks";
    icon = "gnome-tweaks";
    type = "Application";
    categories = [ "Settings" "Utility" ];
    comment = "Adjust advanced GNOME settings";
  };

  xdg.desktopEntries."vscode" = {
    name = "Visual Studio Code";
    exec = "${pkgs.vscode}/bin/code";
    icon = "vscode";
    type = "Application";
    categories = [ "Development" "IDE" ];
    comment = "Code editor redefined and reimagined";
  };

  xdg.desktopEntries."jetbrains-toolbox" = {
    name = "JetBrains Toolbox";
    exec = "${pkgs.jetbrains-toolbox}/bin/jetbrains-toolbox";
    icon = "jetbrains-toolbox";
    type = "Application";
    categories = [ "Development" "IDE" ];
    comment = "Manage your JetBrains tools with ease";
  };

  xdg.desktopEntries."postman" = {
    name = "Postman";
    exec = "${pkgs.postman}/bin/postman";
    icon = "postman";
    type = "Application";
    categories = [ "Development" "Network" ];
    comment = "API development environment";
  };

  xdg.desktopEntries."wireshark" = {
    name = "Wireshark";
    exec = "${pkgs.wireshark}/bin/wireshark";
    icon = "wireshark";
    type = "Application";
    categories = [ "Network" "Utility" ];
    comment = "Network protocol analyzer";
  };

  xdg.desktopEntries."lazydocker" = {
    name = "Lazydocker";
    exec = "${pkgs.lazydocker}/bin/lazydocker";
    icon = "lazydocker"; # You might need to ensure this icon exists or use a generic one
    type = "Application";
    categories = [ "Development" "System" ];
    comment = "A simple terminal UI for docker and docker-compose";
  };

  xdg.desktopEntries."anydesk" = {
    name = "AnyDesk";
    exec = "${pkgs.anydesk}/bin/anydesk";
    icon = "anydesk";
    type = "Application";
    categories = [ "Network" "RemoteAccess" ];
    comment = "Desktop sharing application, providing remote support and online meetings";
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
