{
  disko.devices = {
    disk = {
      nvme0n1 = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              type = "EF00"; # EFI system partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "128G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                extraArgs = "-L nixos"; # Додаємо мітку для /dev/disk/by-label/nixos
              };
            };
            home = {
              size = "100%"; # Використати весь залишковий простір
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
                extraArgs = "-L home"; # Додаємо мітку для /dev/disk/by-label/home
              };
            };
          };
        };
      };
    };
  };
}
