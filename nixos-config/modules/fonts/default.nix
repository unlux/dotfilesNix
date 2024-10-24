{ pkgs, ... }:
let
  commitmonolux = pkgs.callPackage.cdefault.nix { inherit pkgs; };
in
{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      jetbrains-mono
      commitmonolux
    ];
  };
}
