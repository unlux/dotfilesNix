{
  pkgs,
  hostname,
  username,
  lib,
  config,
  ...
}: {
  networking = {
    hostName = hostname;
    nat = {
      enable = true;
      internalInterfaces = ["virbr0"];
    };
    networkmanager = {
      enable = true;
      wifi.backend = lib.mkDefault "iwd";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        22000
        21027
        3131
        53
      ];
      allowedUDPPorts =
        [22 80 443 22000 21027 3131 53 67]
        ++ (lib.optional config.services.tailscale.enable config.services.tailscale.port);
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      checkReversePath = "loose";
      trustedInterfaces =
        ["tailscale0"]
        ++ (lib.optional config.services.tailscale.enable "tailscale0");
    };
    hosts = {
      # "127.0.0.1:8384" = [ "syncthing" ];
    };
    enableIPv6 = true;
  };

  environment.systemPackages = with pkgs; [
    tcpdump
    inetutils
    rclone
    rsync
    # cloudflare-warp
    # cloudflared
  ];

  # services.teamviewer.enable = true;

  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--shields-up"
      "--operator=${username}"
      "--ssh"
    ];
  };

  # systemd.packages = [pkgs.cloudflare-warp];
  # systemd.services."warp-svc".wantedBy = ["multi-user.target"];
  # systemd.user.services."warp-taskbar".wantedBy = ["tray.target"];
}
