{
  pkgs,
  pkgs-stable,
  ...
}: {
  imports = [
    # ../docker/dockerrootless.nix
  ];

  environment.systempackages =
    (with pkgs; [
      ])
    ++ (with pkgs-stable; [
      wezterm
      neovim
      microsoft-edge
      chromium
      # virt-manager
      home-manager
      python3
      bat
      fastfetch
      fzf
      gnumake
      mpv
      rsync
      wget
      yadm
      zoxide

      # utils
      lshw
      pciutils
      usbutils
      xdg-utils

      # archive tools
      p7zip
      unzip
      zip

      # miscellaneous tools
      git
      ntfs3g
      ripgrep # recursively searches directories for a regex pattern
      cowsay
      file
      gawk
      tree
      appimage-run

      # system monitoring tools
      btop # replacement of htop/nmon
      iotop # io monitoring
    ]);

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-6.0.36"
  ];
}
