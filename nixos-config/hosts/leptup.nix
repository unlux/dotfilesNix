# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  pkgs,
  pkgs-stable,
  config,
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

  # specialisation.no-leptup-keyboard.configuration = {
  #   boot.kernelParams = lib.mkForce ["i8042.nokbd"];
  # }; # for use with external keyboard

  security.sudo-rs.enable = true;

  boot.blacklistedKernelModules = ["btmtk"]; # MediaTek Bluetooth driver
  services.udev.extraRules = ''
    SUBSYSTEM=="bluetooth", ATTR{address}=="A8:6E:84:20:D8:B7", ATTR{powered}="0"
  '';

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # environment.systemPackages = [pkgs.distrobox];

  # services.sunshine = {
  #   enable = true;
  #   autoStart = true;
  #   capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
  #   openFirewall = true;
  #   package = pkgs.sunshine.override {
  #     cudaSupport = true;
  #   };
  # };

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
      # zed-editor

      virt-manager
      home-manager

      # Language
      lua
      python3
      # rustup

      # Terminal utilities
      # oh-my-posh
      bat
      eza
      fd
      fastfetch
      ffmpeg
      # devbox
      fzf
      mpv
      rsync
      tldr
      tmux
      # wezterm
      wget
      yadm

      # System utilities
      lshw
      pciutils
      usbutils
      xdg-utils
      iptables
      nmap

      # Archive tools
      # p7zip
      unzip
      zip

      # Miscellaneous tools
      git
      ntfs3g
      ripgrep # recursively searches directories for a regex pattern
      cowsay
      file
      gawk
      # gnupg
      # gnused
      # gnumake
      # gnutar
      # nnn # terminal file manager
      tree
      # zstd
      appimage-run

      # System monitoring tools
      btop # replacement of htop/nmon
      iotop # io monitoring
      # lm_sensors # for `sensors` command
      # lsof # list open files
      # strace # system call monitoring
      # sysstat

      # Data processing
      # jq # A lightweight and flexible command-line JSON processor
      # yq-go # yaml processor https://github.com/mikefarah/yq

      # Other/Optional
      # glow # markdown previewer in terminal
      # hugo # static site generator

      #CYBER PKGS
      # gobuster
      # seclists
      # netcat-openbsd
      # ethtool
      # iftop # network monitoring
      # ltrace # library call monitoring
      # aria2 # A lightweight multi-protocol & multi-source command-line download utility
      # dnsutils # `dig` + `nslookup`
      # iperf3
      # ipcalc # it is a calculator for the IPv4/v6 addresses
      # ldns # replacement of `dig`
      # mtr # A network diagnostic tool
      # socat # replacement of openbsd-netcat
      # wireshark
      openssl.dev
    ])
    ++ (with pkgs-stable; [
      # floorp
      cargo # need old version coz prisma-engine's `time` module build failing
    ]);

  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    TERMINAL = "ghostty";
    MOZ_ENABLE_WAYLAND = 1;
  };

  services.hardware.openrgb.enable = true; # openrgb udev rules
  services.ratbagd.enable = true; # piper

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
