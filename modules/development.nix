{ config, pkgs, ... }:

{
  # Development packages
  environment.systemPackages = with pkgs; [
    # Programming Languages & Runtimes
    ## Web Development
    nodejs
    php
    python3
    ## Compiled Languages
    jdk
    dotnet-sdk
    gcc
    clang

    # Package Managers & Build Tools
    ## JavaScript/Node.js
    yarn
    pnpm

    ## PHP
    phpPackages.composer

    ## Java
    maven
    gradle

    ## Python
    poetry

    ## C/C++
    gnumake
    cmake

    # Code Editors & IDEs
    vscode
    nano
    neovim
    jetbrains-toolbox

    # Version Control
    git
    gh

    # API Development & Testing
    postman
    curl

    # Data Processing
    jq
    yq-go

    # Cloud & DevOps
    azure-cli

    # Network Analysis
    nmap
    wireshark
    adguardian

    # Multimedia
    ffmpeg

    # CI/CD
    jenkins
  ];

  # Programs
  programs.wireshark.enable = true;
  programs.neovim.enable = true;

  # Services
  services.jenkins.enable = true;
}
