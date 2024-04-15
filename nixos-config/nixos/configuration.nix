# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  # outputs,
  # lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example


    # modules
    ../modules/batterysavers.nix
    ../modules/gnome.nix
    ../modules/locale.nix
    ../modules/openssh.nix
    ../modules/pipewire.nix
    # ../modules/services.nix
    ../modules/zsh.nix
    ../modules/grub.nix

    ../modules/gpuPassthrough.nix
    ../modules/nvidia.nix 
    ../modules/dockerRootless.nix
    ../modules/kvm.nix

    # ../modules/systemd.nix
    



    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # home-manager
    inputs.home-manager.nixosModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];


  # nixpkgs = {
  #   # Configure your nixpkgs instance
  #   config = {
  #     # Disable if you don't want unfree packages
  #     allowUnfree = true;
  #   };
  # };

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
  
  
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 22 80 443];
    # firewall.enable = true;
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = ["nix-command" "flakes"];
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  nixpkgs = {
    #Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb.layout = "us";
    libinput.enable = true;
    #xkbVariant = "";
  };

  # Enable CUPS to print document.
  # services.printing.enable = true;


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  
  
  users.users = {
    lux = {
      # initialPassword = "  ";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKiEzG/bxLrAXpvjt5hU4mj6bfcYC/OifFyjW9pI2fV4 lakshaychoudhary77712@google.com"
      ];
      
      extraGroups = 
        [ "wheel" "networkmanager" "docker" 
          "qemu-libvirtd" "libvirtd" "adbusers" ];
      
      packages = with pkgs; [

      ];
    };
  };

  # xdg.portal.wlr.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    qdirstat
    floorp
    vscode

    # virtualisation shi
    virt-manager
    looking-glass-client

    home-manager
    libreoffice-fresh
    auto-cpufreq

    # langchains and shi
    python3
    nodejs_21	
    nodePackages.pnpm
    rustup
    cargo

    # electron_28

    # terminal utils
    wezterm
    wget
    zoxide
    ffmpeg
    #devbox
    fwupd
    fastfetch
    starship
    ugrep
    ripgrep
    atuin
    fd
    pciutils
    usbutils
    inetutils
    yadm
    fzf
    eza
    bat
    lshw
    mpv
    tldr
    rsync
    tmux
    tree
    xdg-utils

    # cyber shi
    nmap
    iptables
    netcat-openbsd

    oh-my-zsh

    # needed shi
    gcc
    git
    piper
    openrgb
    ntfs3g

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool

    # archives
    zip
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    nnn # terminal file manager

  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      lux = import ../home-manager/home.nix;
    };
  };


  # services.qemuGuest.enable=true;

  
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";

}
