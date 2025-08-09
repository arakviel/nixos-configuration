{ config, pkgs, ... }:

{
  # Fonts configuration
  fonts = {
    packages = with pkgs; [
      # Core fonts
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      # Microsoft fonts (Times New Roman, Arial, etc.)
      corefonts
      vistafonts

      # Open source alternatives
      liberation_ttf
      dejavu_fonts

      # Icon theme
      papirus-icon-theme
    ];

    # Font configuration
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Times New Roman" "Liberation Serif" ];
        sansSerif = [ "Arial" "Liberation Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" "Liberation Mono" ];
      };
    };
  };
}