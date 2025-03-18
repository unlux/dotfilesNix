{
  pkgs,
  namespace,
  lib,
  ...
}: let
  # commitmonolux = pkgs.callPackage.nix ./commitmono.nix {};
  # customFont = pkgs.callPackage ./monolisa.nix {};
in {
  # imports = [
  # ./monolisa.nix
  # ./commitmono.nix
  #   # ./fontConfig.nix
  # ];
  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.commit-mono
      # commitmonolux
      # customFont
      # pkgs.monolisa-nerdfonts
    ];
  };
}
