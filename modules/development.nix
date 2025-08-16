{ config, pkgs, ... }: # Reverted 'lib' argument

{
  # Development packages
  environment.systemPackages = with pkgs; [
    # Programming Languages & Runtimes
    ## Web Development
    nodejs
    php
    python3
    ## Compiled Languages
    jdk24
    dotnet-sdk_9
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
    nano
    neovim
    vscode

    # JetBrains IDEs
    jetbrains.phpstorm
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
    jetbrains.rider
    jetbrains.datagrip
    android-studio

    # Version Control
    git
    gh

    # API Development & Testing
    postman
    curl

    # Data Processing
    jq
    yq-go

    # Tunneling & Networking
    ngrok  # Secure tunnels to localhost

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
