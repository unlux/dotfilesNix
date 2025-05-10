# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{...}: {
  imports = [
    ./base.nix
    ../modules/system/system-packages-pc.nix

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-pc-ssd

    # home-manager
    # inputs.home-manager.nixosModules.default

    # ./pc-hardware.nix
  ];

  # # This will add each flake input as a registry
  # # To make nix3 commands consistent with your flake
  # nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # # This will additionally add your inputs to the system's legacy channels
  # # Making legacy nix commands consistent as well, awesome!
  # nix.nixPath = ["/etc/nix/path"];
  # environment.etc =
  #   lib.mapAttrs'
  #   (name: value: {
  #     name = "nix/path/${name}";
  #     value.source = value.flake;
  #   })
  #   config.nix.registry;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # auto-optimise-store = true;
  };

  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = false;

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  users.users = {
    someow = {
      isNormalUser = true;
      initialPassword = "jj";
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "qemu-libvirtd"
        "libvirtd"
        "kvm"
        "adbusers"
      ];
      # packages = with pkgs; [
      #   # user specific pkgs
      # ];
    };
    lux = {
      isNormalUser = true;
      initialPassword = "jj";
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "qemu-libvirtd"
        "libvirtd"
        "kvm"
        "adbusers"
      ];
      # packages = with pkgs; [
      #   # user specific pkgs
      # ];
    };
  };

  environment.systempackages =
    (with pkgs; [
      ])
    ++ (with pkgs-stable; [
      wezterm
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

  # xdg.portal.wlr.enable = true;

  # home-manager = {
  #   extraSpecialArgs = { inherit inputs; };
  #   users = {
  #     lux = import ./home.nix;
  #   };
  # };

  # services.qemuGuest.enable=true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
