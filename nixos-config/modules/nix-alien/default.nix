{
  pkgs,
  inputs,
  ...
}: {
  # Enable nix-ld
  programs.nix-ld.enable = true;

  # Add nix-alien packages from flake input
  environment.systemPackages = [
    inputs.nix-alien.packages.${pkgs.system}.nix-alien
  ];

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
