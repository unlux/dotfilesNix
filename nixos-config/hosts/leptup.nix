# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
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
    ../modules/nvidia/default.nix
    # ../modules/nvidia/gpuPassthrough.nix
    ../modules/gaming/default.nix
    # ../modules/prisma/default.nix
    # ../modules/kubernetes/default.nix
    # ../modules/iphone/default.nix
    # ../modules/ollama/default.nix
    # ../modules/printing/default.nix
    # ../overlays/default.nix
    # ../modules/plymouth/default.nix
    ../modules/stylix/default.nix
    ../modules/fonts/default.nix
    ../modules/custom/download-sorter.nix
    ../modules/android/default.nix
    ../modules/custom/zen-autobackup.nix
    # ../modules/custom/mpris-proxy.nix

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-pc-ssd

    # home-manager
    inputs.home-manager.nixosModules.default
    ./leptup-hardware.nix
  ];

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
  };

  # users.users.lux = {
  #   shell = pkgs.nushell;
  # };

  boot.kernelPackages = pkgs.linuxPackages_6_6; # use 6.6 LTS kernel
  boot.blacklistedKernelModules = ["btmtk"]; # MediaTek Bluetooth driver

  # specialisation.no-leptup-keyboard.configuration = {
  #   boot.kernelParams = lib.mkForce ["i8042.nokbd"];
  # }; # for use with external keyboard

  security.sudo-rs.enable = true;

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="bluetooth", ATTR{address}=="A8:6E:84:20:D8:B7", ATTR{powered}="0"
  '';

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
    };
  };

  services.syncthing = {
    enable = true;
    # configDir = ""
    openDefaultPorts = true;
    systemService = true;
    user = "lux";
    group = "syncthing";
    dataDir = "/home/lux";
  };

  environment.systemPackages =
    (with pkgs; [
      alacritty
      home-manager
      appimage-run
      openssl.dev
      ghostty
      # thefuck
      pay-respects
    ])
    ++ (with pkgs-stable; [
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
      rsync
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
      nvtopPackages.full
    ]);

  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    TERMINAL = "ghostty";
    MOZ_ENABLE_WAYLAND = 1;
  };

  services.hardware.openrgb.enable = true; # openrgb udev rules
  services.ratbagd.enable = true; # piper

  services.earlyoom = {
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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
