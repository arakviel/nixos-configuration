{ config, lib, pkgs, disko, ... }:

{
  # CPU Microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # NVIDIA GPU configuration
  hardware.nvidia = {
    # Увімкнення пропрієтарного драйвера NVIDIA
    modesetting.enable = true; # Рекомендується для сучасних систем
    powerManagement.enable = false; # Вимкнення управління живленням (опціонально, залежить від ваших потреб)
    powerManagement.finegrained = false; # Для карт, які не підтримують Prime
    open = false; # Використовуємо пропрієтарний драйвер, а не відкритий
    nvidiaSettings = true; # Увімкнення утиліти nvidia-settings
    package = config.boot.kernelPackages.nvidiaPackages.stable; # Використовуємо стандартний пакет драйверів
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Вкажіть вашу відеокарту
  services.xserver.videoDrivers = [ "nvidia" ];

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
