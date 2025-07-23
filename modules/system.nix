{ config, pkgs, ... }:

{
  # General system settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # Localization settings
  i18n.defaultLocale = "en_US.UTF-8"; # Англійська мова для інтерфейсу системи
  i18n.extraLocaleSettings = {
    LC_TIME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8"; 
    LC_MONETARY = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
  };

  time.timeZone = "Europe/Kiev"; # Set your timezone

  nixpkgs.config.allowUnfree = true;
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 7d";

  # Audio (PipeWire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Sudo
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;
}