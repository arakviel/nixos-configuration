{ config, pkgs, ... }:

{
  # Networking configurations
  networking.hostName = "arakviel-pc";
  networking.networkmanager.enable = true;

  services.openssh.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 20 21 22 23 25 53 80 143 443 465 587 993 995 3306 5432 8080 ];
  networking.firewall.allowedTCPPortRanges = [
  { from = 3000; to = 3000; } # Наприклад, для React/Node.js
  { from = 5000; to = 5000; } # Наприклад, для Flask/FastAPI
  { from = 8000; to = 8000; } # Наприклад, для Django
  { from = 8080; to = 8080; } # Альтернатива HTTP
  { from = 9000; to = 9000; } # Для API або серверів розробки
  { from = 49152; to = 65535; } # Динамічний діапазон для тестування
  ];
  networking.firewall.allowedUDPPorts = [ 53 67 123 ];
  networking.firewall.allowedUDPPortRanges = [
    { from = 49152; to = 65535; } # Динамічний діапазон для тестування
  ];
}
