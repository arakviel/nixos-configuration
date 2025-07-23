{ config, lib, pkgs, ... }:

{
  # CPU Microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # NVIDIA GPU configuration
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}