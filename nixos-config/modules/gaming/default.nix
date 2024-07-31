{ config, pkgs, ... }:
{
  imports = [
  ./specialisation.nix
  ];

  programs.gamemode.enable = true;

  # steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  # protonup
  environment.systemPackages = with pkgs; [
    protonup
    mangohud
    heroic
  ];
  
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };
}