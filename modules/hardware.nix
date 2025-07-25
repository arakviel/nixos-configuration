{ config, lib, pkgs, ... }:

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
}
