{ config, pkgs, ... }:

{
  # User configuration
  users.users.arakviel = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd" "audio" ];
    hashedPassword = "$6$09GR2hlNoAoT6.qt$JD.ooTWPutO0Q3NoDJeqTUBWX5endF2haeX.XxyLZUErY0SYRAxqgXwEOEEV0CLw3n0NYQ0vikthgSX0UtVtq.";
    shell = pkgs.fish;
  };
}
