{pkgs, ...}: {
  imports = [./specialisation.nix];

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
    };
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    protonup
    mangohud
    heroic

    # https://github.com/PhilT/nixos-files/blob/8b0f83eda1be94a38ba51735c3caaddaa922a7f6/src/gaming.nix
    game-devices-udev-rules # Udev rules to make controllers available with non-sudo permissions
    # lutris # For non-steam games from other app stores or local, also supports steam games
    jstest-gtk # For testing Joysticks
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
