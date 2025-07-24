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
    jetbrains.phpstorm
    jetbrains.rider
    jetbrains.clion
    jetbrains.idea-ultimate
    jetbrains.datagrip
    jetbrains.pycharm-professional

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
  ];

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