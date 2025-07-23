{ config, pkgs, ... }:

{
  # System-wide font configurations
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    papirus-icon-theme
  ];
}