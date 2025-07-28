{ config, lib, pkgs, ... }:

{
  # File systems configuration using UUIDs
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a96dbf43-bf93-46b3-8ff1-ab05658ec17b";
    fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/49EF-3D8C";
    fsType = "vfat";
    options = [ "defaults" "umask=0077" ];
  };

  # Swap configuration (if needed)
  # swapDevices = [
  #   { device = "/dev/disk/by-uuid/your-swap-uuid"; }
  # ];

  # Additional mount options for better performance and security
  boot.tmp.cleanOnBoot = true;
  
  # Enable periodic TRIM for SSD optimization
  services.fstrim.enable = true;
}