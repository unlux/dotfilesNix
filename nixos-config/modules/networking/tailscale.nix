{
  config,
  username,
  ...
}: {
  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--shields-up"
      "--operator=${username}"
      "--ssh"
    ];
  };
  networking = {
    firewall = {
      allowedUDPPorts = [config.services.tailscale.port];
      checkReversePath = "loose";
      trustedInterfaces = ["tailscale0"];
    };
  };
}
