# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  # outputs,
  # lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # modules
    ../modules/power.nix
    ../modules/cloudflare-warp.nix
    ../modules/dockerRootless.nix
    ../modules/gpuPassthrough.nix
    ../modules/grub.nix
    ../modules/gnome/gnome2.nix
    # ../modules/gnome/gnome.nix
    ../modules/kvm.nix
    ../modules/locale.nix
    ../modules/nvidia.nix 
    # ../modules/nixHelper.nix
    ../modules/openssh.nix
    ../modules/pipewire.nix
    ../modules/xserver.nix
    ../modules/zsh.nix
    # ../modules/systemd.nix
    ../modules/networking/tailscale.nix
    ../modules/networking/default.nix
    


    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # home-manager
    inputs.home-manager.nixosModules.default

    ./hardware-configuration.nix
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
    experimental-features = ["nix-command" "flakes"];
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
    lux = {
      # initialPassword = "  ";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # Add your SSH public key(s) here, if you plan on using SSH to connect
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKiEzG/bxLrAXpvjt5hU4mj6bfcYC/OifFyjW9pI2fV4 lakshaychoudhary77712@google.com"
      ];
      extraGroups = 
        [ "wheel" "networkmanager" "docker" 
          "qemu-libvirtd" "libvirtd" "adbusers" ];
      packages = with pkgs; [
        # user specific pkgs
      ];
    };
  };

  # xdg.portal.wlr.enable = true;

  environment.systemPackages = with pkgs; [
    # Editors
    neovim
    vscode
    # zed-editor

    # browesers
    floorp

    # Virtualisation tools
    looking-glass-client
    virt-manager

    # Home manager and office tools
    home-manager
    libreoffice-fresh
    qdirstat

    # Language chains
    cargo
    lua
    nodejs_21	
    nodePackages.pnpm
    python3
    rustup
    # electron_28

    # Terminal utilities
    atuin
    auto-cpufreq
    bat
    eza
    fd
    fastfetch
    ffmpeg
    #devbox
    fzf
    gnumake
    inetutils
    lshw
    mpv
    pciutils
    rsync
    starship
    tldr
    tmux
    tree
    usbutils
    wezterm
    wget
    xdg-utils
    yadm
    zoxide

    # Cybersecurity tools
    iptables
    nmap
    netcat-openbsd
    ethtool
    iftop # network monitoring
    ltrace # library call monitoring

    # Shell
    oh-my-zsh

    # Development tools
    gcc
    git
    ntfs3g
    openrgb
    piper

    # Nix related
    nix-output-monitor
    nh
    nvd
    # it provides the command `nom` works just like `nix`
    # with more details log output

    # Productivity tools
    glow # markdown previewer in terminal
    hugo # static site generator

    # System monitoring tools
    btop  # replacement of htop/nmon
    iotop # io monitoring
    lm_sensors # for `sensors` command
    lsof # list open files
    strace # system call monitoring
    sysstat

    # Archive tools
    p7zip
    unzip
    zip

    # Utility tools
    jq # A lightweight and flexible command-line JSON processor
    ripgrep # recursively searches directories for a regex pattern
    yq-go # yaml processor https://github.com/mikefarah/yq

    # Networking tools
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    dnsutils  # `dig` + `nslookup`
    iperf3
    ipcalc  # it is a calculator for the IPv4/v6 addresses
    ldns # replacement of `dig`, it provide the command `drill`
    mtr # A network diagnostic tool
    nmap # A utility for network discovery and security auditing
    socat # replacement of openbsd-netcat

    # Miscellaneous tools
    cowsay
    file
    gawk
    gnupg
    gnused
    gnutar
    nnn # terminal file manager
    tree
    zstd

    wl-clipboard  

    
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      lux = import ./home.nix;
    };
  };
  
  services.teamviewer.enable = true;
  # for ozone
  environment.sessionVariables.NIXOS_OZONE_WL = "1";


  # services.qemuGuest.enable=true;
  
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";

}
