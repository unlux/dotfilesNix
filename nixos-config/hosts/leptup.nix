{
  inputs,
  pkgs,
  pkgs-stable,
  system,
  ...
}: {
  imports = [
    ./base.nix
    ../modules/system/kvm.nix
    ../modules/system/power.nix
    # ../modules/system/noisecancel.nix
    ../modules/system/bluetooth.nix
    # ../modules/nvidia/default.nix
    # ../modules/nvidia/gpuPassthrough.nix
    ../modules/gaming/default.nix
    # ../modules/prisma/default.nix
    # ../modules/kubernetes/default.nix
    # ../modules/iphone/default.nix
    # ../modules/ollama/default.nix
    # ../modules/printing/default.nix
    # ../overlays/default.nix
    ../modules/plymouth/default.nix
    ../modules/stylix/default.nix
    ../modules/fonts/default.nix
    ../modules/custom/download-sorter.nix
    ../modules/android/default.nix
    ../modules/custom/zen-autobackup.nix
    ../modules/python/default.nix
    # ../modules/custom/mpris-proxy.nix
    # ../modules/adblock/blocky.nix

    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate

    inputs.self.nixosModules.nvidia
    inputs.home-manager.nixosModules.default
    ./leptup-hardware.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  easyNvidia = {
    enable = true;
    withIntegratedGPU = true;
    vaapi.firefox.av1Support = true;
    desktopEnvironment = "gnome";
  };

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:5:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # xdg.portal.wlr.enable = true;

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/lux/.ssh/keys.txt";

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      lux = import ./home.nix;
    };
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # users.users.lux = {
  #   shell = pkgs.nushell;
  # };

  boot.blacklistedKernelModules = ["btmtk"]; # MediaTek Bluetooth driver

  security.sudo-rs.enable = true;

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  services = {
    sunshine = {
      enable = false;
      autoStart = true;
      capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
      openFirewall = true;
      package = pkgs.sunshine.override {
        cudaSupport = true;
      };
    };

    earlyoom = {
      enable = true;
      freeSwapThreshold = 2; # in percent
      freeMemThreshold = 2; # in percent
      enableNotifications = true;
      extraArgs = [
        # "-g"
        # "--avoid '(^|/)(init|Xorg|ssh)$'"
        # "--prefer '(^|/)(java|chromium)$'"
      ];
    };

    syncthing = {
      enable = true;
      # configDir = ""
      openDefaultPorts = true;
      systemService = true;
      user = "lux";
      group = "syncthing";
      dataDir = "/home/lux";
    };

    udev.extraRules = ''
      SUBSYSTEM=="bluetooth", ATTR{address}=="A8:6E:84:20:D8:B7", ATTR{powered}="0"
    '';
    hardware.openrgb.enable = true; # openrgb udev rules
    ratbagd.enable = true; # piper
  };

  environment.systemPackages =
    (with pkgs; [
      alacritty
      home-manager
      appimage-run
      openssl.dev
      ghostty
      pay-respects
    ])
    ++ (with pkgs-stable; [
      vivid
      virt-manager
      lua
      python3
      lshw
      pciutils
      usbutils
      xdg-utils
      iptables
      nmap
      unzip
      zip
      bat
      eza
      fd
      fastfetch
      ffmpeg
      fzf
      mpv
      tldr
      tmux
      wget
      yadm
      git
      ntfs3g
      file
      gawk
      tree
      btop
      iotop
      cargo
      # nvtopPackages.full
    ]);

  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    TERMINAL = "ghostty";
    MOZ_ENABLE_WAYLAND = 1;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
