{
  config,
  inputs,
  lib,
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
    ../modules/kubernetes/default.nix
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
    ../modules/custom/shanwan-controller.nix
    ../modules/python/default.nix
    ../modules/custom/ydotool.nix
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

  easyNvidia = {
    enable = true;
    withIntegratedGPU = true;
    vaapi.enable = true; # Use NVIDIA for video decode (smoother, has AV1)
    vaapi.firefox.av1Support = true;
    desktopEnvironment = "plasma";
  };

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:5:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  hardware.nvidia.powerManagement.finegrained = lib.mkForce false;
  hardware.nvidia.open = lib.mkForce false; # Proprietary driver so NVreg_EnableGpuFirmware=0 actually works

  # NVIDIA composites the desktop (smoother overview/animations), AMD stays available
  environment.variables.KWIN_DRM_DEVICES = lib.mkIf config.easyNvidia.enable (lib.mkForce "/dev/dri/dgpu1:/dev/dri/igpu1");

  # xdg.portal.wlr.enable = true;

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/etc/sops/age/keys.txt";

  home-manager = {
    extraSpecialArgs = {
      inherit inputs pkgs-stable;
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

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  security.sudo-rs.enable = true;

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  services = {
    sunshine = {
      enable = true;
      autoStart = true; # disabled if service is not enabled
      capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
      openFirewall = true;
      package = pkgs-stable.sunshine.override {
        cudaSupport = true;
      };
      settings = {
        adapter_name = "/dev/dri/card2";  # NVIDIA GPU that owns DP-1
        encoder = "nvenc";
        output_name = "DP-1";
      };
    };

    earlyoom = {
      enable = true;
      freeSwapThreshold = 5; # in percent
      freeMemThreshold = 5; # in percent
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
      KERNEL=="card1", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="high"
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
      ntfs3g
      file
      gawk
      tree
      btop
      iotop
      cargo
      sops
      lsof
      ripgrep
      # nvtopPackages.full
    ]);

  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    TERMINAL = "ghostty";
    MOZ_ENABLE_WAYLAND = 1;
    YDOTOOL_SOCKET = "/run/user/1000/.ydotool_socket";
    # GSK_RENDERER = "gl"; # GNOME/GTK4 NVIDIA workaround, not needed on KDE
  };

  # Sunshine environment overrides removed — NVENC uses NVIDIA EGL natively

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
