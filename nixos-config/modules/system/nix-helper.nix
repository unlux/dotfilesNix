# { config, pkgs, ... }:

# {
#   programs.nh = {
#     enable = true;
#     # clean.enable = true;
#     # clean.extraArgs = "--keep-since 4d --keep 3";
#     flake = "/home/lux/nixos-config";
#   };
# }


{ config, lib, pkgs, pkgs-stable, ... }:

{
  environment.systemPackages = (with pkgs; [
    nix-output-monitor
    nh
    nvd
    nix-index
    nixpkgs-fmt

  ]);
}
