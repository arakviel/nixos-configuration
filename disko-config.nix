{ lib, pkgs, ... }:

{
  disko.devices = {
    disk = {
      arakviel-disk = {
        device = "/dev/nvme1n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" "umask=0077" "iocharset=iso8859-1" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                extraArgs = [ "-L" "nixos" ];
                mountOptions = [ "defaults" "noatime" "errors=remount-ro" ];
              };
            };
          };
        };
      };
    };
  };

  # Configure fileSystems to use UUIDs instead of device paths
  # This overrides Disko's default device-based configuration
  fileSystems = {
    "/" = lib.mkForce {
      device = "/dev/disk/by-uuid/a96dbf43-bf93-46b3-8ff1-ab05658ec17b";
      fsType = "ext4";
      options = [ "defaults" "noatime" "errors=remount-ro" ];
      autoResize = true;  # Automatically resize filesystem to fill partition
    };
    "/boot" = lib.mkForce {
      device = "/dev/disk/by-uuid/49EF-3D8C";
      fsType = "vfat";
      options = [ "defaults" "umask=0077" "iocharset=iso8859-1" ];
    };
  };

  # Enable periodic TRIM for SSD optimization
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Clean /tmp on boot
  boot.tmp.cleanOnBoot = true;

  # Automatic filesystem resize service
  systemd.services.resize-root-filesystem = {
    description = "Resize root filesystem to fill partition";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.e2fsprogs}/bin/resize2fs /dev/disk/by-uuid/a96dbf43-bf93-46b3-8ff1-ab05658ec17b";
      StandardOutput = "journal";
      StandardError = "journal";
    };
    # Only run if the filesystem needs resizing
    unitConfig.ConditionPathExists = "/dev/disk/by-uuid/a96dbf43-bf93-46b3-8ff1-ab05658ec17b";
  };
}
