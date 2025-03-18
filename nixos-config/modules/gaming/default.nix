{pkgs, ...}: {
  imports = [./specialisation.nix];

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      # localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      # gamescopeSession.enable = true;
    };
    # gamescope = {
    #   enable = true;
    #   capSysNice = true;
    # };
    gamemode.enable = true;
  };

  hardware.xone.enable = true; # support for the xbox controller USB dongle

  environment.systemPackages = with pkgs; [
    protonup
    mangohud
    heroic

    # https://github.com/PhilT/nixos-files/blob/8b0f83eda1be94a38ba51735c3caaddaa922a7f6/src/gaming.nix
    game-devices-udev-rules # Udev rules to make controllers available with non-sudo permissions
    lutris # For non-steam games from other app stores or local, also supports steam games
    jstest-gtk # For testing Joysticks
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
