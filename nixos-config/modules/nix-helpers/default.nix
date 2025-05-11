# { config, pkgs, ... }:
# {
#   programs.nh = {
#     enable = true;
#     # clean.enable = true;
#     # clean.extraArgs = "--keep-since 4d --keep 3";
#     flake = "/home/lux/nixos-config";
#   };
# }
{pkgs, ...}: {
  environment.systemPackages =
    (with pkgs; [
      nix-output-monitor
      nh
      nvd
      nix-index
      nixpkgs-fmt
      alejandra
    ])
    ++ [
      # inputs.nix-alien.packages.${pkgs.system}.nix-alien
    ];

  # Enable nix-ld
  programs.nix-ld.enable = true;

  # Sets up all the libraries to load
  programs.nix-ld.libraries = with pkgs; [
    gcc
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    libunwind
    # ...
  ];
}
