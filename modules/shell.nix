{ config, pkgs, ... }:

{
  # Shell configuration
  programs.fish = {
    enable = true;
    shellInit = ''
      starship init fish | source
      direnv hook fish | source
    '';
  };

  programs.starship.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}