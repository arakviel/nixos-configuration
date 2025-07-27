{ config, pkgs, ... }:

{
  # VPN configuration
  services.openvpn.servers = {
    openvpn = {
      config = ''
        config /etc/openvpn/client/main.ovpn
      '';
      autoStart = false;
    };
  };

  # Create OpenVPN client directory
  systemd.tmpfiles.rules = [
    "d /etc/openvpn/client 0755 root root -"
  ];

  # NetworkManager OpenVPN support
  environment.systemPackages = with pkgs; [
    networkmanager-openvpn
    openvpn
  ];

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];
}