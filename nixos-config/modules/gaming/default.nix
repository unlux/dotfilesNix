{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true; #
      # localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--steam"
        "--expose-wayland"
        "--rt"
        "-W 1920"
        "-H 1080"
        "--force-grab-cursor"
        "--grab"
        "--fullscreen"
      ];
    };
    gamemode.enable = true;
  };

  hardware.xone.enable = true; # support for the xbox controller USB dongle

  environment.systemPackages = with pkgs; [
    protonup
    mangohud
    # heroic
    lutris

    # https://github.com/PhilT/nixos-files/blob/8b0f83eda1be94a38ba51735c3caaddaa922a7f6/src/gaming.nix
    game-devices-udev-rules # Udev rules to make controllers available with non-sudo permissions
    # jstest-gtk # For testing Joysticks
  ];
}
