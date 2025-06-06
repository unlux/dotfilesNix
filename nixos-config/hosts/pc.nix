{
  inputs,
  config,
  pkgs,
  pkgs-stable,
  system,
  ...
}: {
  imports = [
    ./base.nix
    inputs.home-manager.nixosModules.default
    ./pc-hardware.nix
  ];

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
    };
  };

  services.printing = {
    enable = true;
    drivers = [pkgs.hplipWithPlugin];
  };

  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = false;

  environment.systemPackages =
    (with pkgs; [
      ])
    ++ (with pkgs-stable; [
      # wezterm
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
      wget
      yadm

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
      carapace
      vivid
    ]);

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-6.0.36"
  ];

  # xdg.portal.wlr.enable = true;

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      lux = import ./home.nix;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
