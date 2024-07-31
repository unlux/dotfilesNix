{ config, pkgs, hostname, lib, ...}:
{
  networking = {
    hostName = hostname;

    networkmanager = {
      enable = true;
      # Prefer iwd to wpa_supplicant.
      wifi.backend = lib.mkDefault "iwd";
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 22000 21027 ];
      allowedUDPPorts = [ 22000 21027 ];
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; 
    };
  };

  environment.systemPackages = (with pkgs;[
    tcpdump
    inetutils
  ]);
}
