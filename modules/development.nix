{ config, pkgs, ... }:

{
  # Development environment packages and configurations

  environment.systemPackages = with pkgs; [
    # Programming Languages & Ecosystems
    # PHP
    php
    phpPackages.composer

    # CSharp
    dotnet-sdk

    # Java
    jdk
    maven
    gradle

    # JavaScript
    nodejs
    yarn
    pnpm

    # Python
    python3
    poetry

    # C++
    gcc
    gnumake
    cmake
    clang

    # Containerization Tools
    docker

    # Code Editors & IDEs
    vscode
    nano
    neovim

    # JetBrains IDEs
    jetbrains-toolbox
    # jetbrains.phpstorm
    # jetbrains.rider
    # jetbrains.clion
    # jetbrains.idea-ultimate
    # jetbrains.datagrip
    # jetbrains.pycharm-professional

    # Version Control
    git

    # API & Network Tools
    postman
    kubernetes-helm
    kubectl
    azure-cli
    jq
    yq-go
    curl
    nmap
    wireshark
    
    # Other Utilities
    ffmpeg
    jenkins
    lazydocker
    minikube

    # Terminal Emulator
    kitty
  ];

  # Kitty configuration
  environment.etc."xdg/kitty/kitty.conf" = {
    text = ''
      # Font
      font_family      JetBrains Mono Nerd Font
      font_size 11.0

      # Cursor
      cursor_shape beam
      cursor_trail 1

      # Padding (why weird value? consistency with foot)
      window_margin_width 21.75

      # No stupid close confirmation
      confirm_os_window_close 0

      # Use fish shell
      shell fish

      # Copy
      map ctrl+c    copy_or_interrupt

      # Search
      map ctrl+f   launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id
      map kitty_mod+f   launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id

      # Scroll & Zoom
      map page_up    scroll_page_up
      map page_down    scroll_page_down

      map ctrl+plus  change_font_size all +1
      map ctrl+equal  change_font_size all +1
      map ctrl+kp_add  change_font_size all +1
      map ctrl+minus       change_font_size all -1
      map ctrl+underscore       change_font_size all -1
      map ctrl+kp_subtract       change_font_size all -1
      map ctrl+0 change_font_size all 0
      map ctrl+kp_0 change_font_size all 0
    '';
  };

  # User-specific programs
  programs.fish = {
    enable = true;
    shellInit = ''
      starship init fish | source
      direnv hook fish | source # Automatic direnv loading
    '';
  };

  programs.starship.enable = true;
  programs.wireshark.enable = true;

  # Docker daemon configuration
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune = {
    enable = true;
    dates = "weekly";
  };

  # Direnv integration for Nix-shells
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true; # Nix integration

  # Console editors
  programs.neovim.enable = true; # Enable Neovim

  services.jenkins.enable = true;
  virtualisation.libvirtd.enable = true;
}
