{ config, pkgs, ... }:

{
  # Networking
  networking.hostName = "arakviel-pc";
  networking.networkmanager.enable = true;

  # Avahi (mDNS) - disabled for security in security.nix
  # services.avahi.enable = true;
  # services.avahi.nssmdns4 = true;
  # services.avahi.openFirewall = true;

  # Enhanced Firewall Configuration
  networking.firewall = {
    enable = true;

    # Only allow essential ports by default
    allowedTCPPorts = [
      22    # SSH (consider changing default port)
      # 80    # HTTP (only if running web server)
      # 443   # HTTPS (only if running web server)
    ];

    # Development ports (only when needed)
    allowedTCPPortRanges = [
      # Uncomment only the ports you actually need:
      # { from = 3000; to = 3000; }  # React dev server
      # { from = 5000; to = 5000; }  # Flask/other dev servers
      # { from = 8000; to = 8000; }  # Django/other dev servers
      # { from = 8080; to = 8080; }  # Alternative HTTP
      # { from = 9000; to = 9000; }  # Various dev tools
    ];

    # Essential UDP ports
    allowedUDPPorts = [
      # 53    # DNS (only if running DNS server)
      # 67    # DHCP (only if running DHCP server)
      # 123   # NTP (usually not needed for client)
    ];

    # Remove the wide ephemeral port range for security
    allowedUDPPortRanges = [
      # { from = 49152; to = 65535; }  # Removed for security
    ];
  };
}
