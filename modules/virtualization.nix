{ config, pkgs, ... }:

{
  # Virtualization
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune = {
    enable = true;
    dates = "weekly";
  };
  virtualisation.libvirtd.enable = true;

  # Docker packages
  environment.systemPackages = with pkgs; [
    docker
    lazydocker
  ];
}