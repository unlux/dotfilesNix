{ config, pkgs, hostname, lib, ...}:
{
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 22 80 443 ];
    firewall.allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    firewall.allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    firewall.enable = true;
  };
  environment.systemPackages = (with pkgs;[
    tcpdump
    inetutils
  ]);

  # Prefer iwd to wpa_supplicant.
  networking.networkmanager.wifi.backend = lib.mkDefault "iwd";
}
