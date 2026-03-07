{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # NOTE: The nix-index DB is slow to search, until
    # https://github.com/nix-community/nix-index-database/issues/130
    # Use the NixOS module variant here; Home Manager variant isn't needed at system level
    inputs.nix-index-database.nixosModules.nix-index
  ];
  # command-not-found handler to suggest nix way of installing stuff.
  # FIXME: This ought to show new nix cli commands though:
  # https://github.com/nix-community/nix-index/issues/191
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.nix-index-database.comma.enable = true;

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nh
    nvd
    nix-index
    nixpkgs-fmt
    alejandra
  ];

  # Enable nix-ld
  programs.nix-ld.enable = true;

  # Sets up all the libraries to load
  programs.nix-ld.libraries = with pkgs; [
    gcc
    stdenv.cc.cc
    stdenv.cc.cc.lib
    zlib
    fuse3
    icu
    nss
    nspr
    openssl
    curl
    expat
    libunwind

    # GUI libs (Playwright Firefox, Electron, etc.)
    gtk3
    glib
    pango
    cairo
    gdk-pixbuf
    atk
    dbus
    fontconfig
    freetype
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libxcb
    alsa-lib
  ];
}
