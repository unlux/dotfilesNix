{ config, ...}:
{
    networking = {
    hostName = "nixos";
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
}