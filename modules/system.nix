{ config, pkgs, ... }:

{
  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # Localization
  i18n.defaultLocale = "en_US.UTF-8";
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

  time.timeZone = "Europe/Kiev";

  # Kernel parameters to disable audio auto-adjustment
  boot.kernelParams = [
    "snd_hda_intel.power_save=0"
    "snd_hda_intel.power_save_controller=N"
  ];

  nixpkgs.config.allowUnfree = true;
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 7d";



  # Security
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  # System utilities
  environment.systemPackages = with pkgs; [
    wget
    htop
    neofetch
    unzip
    zip
    gnupg
    usbutils
    pciutils
    lshw
    lm_sensors
    smartmontools
    xdg-utils  # For default applications support
  ];

  # Global git configuration
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "arakviel";
        email = "insider.arakviel@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      color = {
        ui = true;
      };
      help = {
        autocorrect = 20;
      };
      credential = {
        helper = "!gh auth git-credential";
      };
      safe = {
        directory = "*";
      };
    };
  };
}