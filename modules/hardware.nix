{ config, lib, pkgs, ... }:

{
  # CPU microcode
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Firmware
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = with pkgs; [ linux-firmware ];

  # Bluetooth
  hardware.bluetooth.enable = true;

  hardware.wirelessRegulatoryDatabase = true;

  # NVIDIA GPU
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  fileSystems = {
    "/" = {
      device = "/dev/nvme1n1p2";
      fsType = "ext4";
      autoResize = true;
    };
    "/boot" = {
      device = "/dev/nvme1n1p1";
      fsType = "vfat";
    };
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  boot.tmp.cleanOnBoot = true;
}
