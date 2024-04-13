# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  # inputs,
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
    ../modules/dockerRootless.nix
    ../modules/gnome.nix
    ../modules/gpuPassthrough.nix
    ../modules/kvm.nix
    ../modules/locale.nix
    ../modules/nvidia.nix
    ../modules/openssh.nix
    ../modules/pipewire.nix
    # ../modules/services.nix
    ../modules/tailscale.nix
    ../modules/zsh.nix
    ../modules/grub.nix
    # ../modules/systemd.nix
    ../modules/flatpak.nix



    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];


  # nixpkgs = {
  #   # You can add overlays here
  #   overlays = [
  #     # Add overlays your own flake exports (from overlays and pkgs dir):
  #     outputs.overlays.additions
  #     outputs.overlays.modifications
  #     outputs.overlays.unstable-packages

  #     # You can also add overlays exported from other flakes:
  #     # neovim-nightly-overlay.overlays.default

  #     # Or define it inline, for example:
  #     # (final: prev: {
  #     #   hi = final.hello.overrideAttrs (oldAttrs: {
  #     #     patches = [ ./change-hello-to-hi.patch ];
  #     #   });
  #     # })
  #   ];
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
          "qemu-libvirtd" "libvirtd"];
    };
  };

  # xdg.portal.wlr.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    qdirstat

    # apps
    discord
    discord-ptb
    webcord
    vlc
    vscode
    ungoogled-chromium
    floorp
    spotify
    snapper-gui
    snapper
    postman
    #warp-terminal
    # obsidian
    notion-app-enhanced
    mongodb-compass
    brave
    #authy
    easyeffects
    telegram-desktop

    # virtualisation shi
    docker
    virt-manager
    looking-glass-client


    home-manager
    libreoffice-fresh
    auto-cpufreq
    syncthing


    # langchains
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
    htop
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
    yadm
    fzf
    eza
    bat
    lshw
    mpv

    # cyber shi
    iftop
    nmap
    iptables
    netcat-openbsd

    # for zsh 
    oh-my-zsh
    # zsh-syntax-highlighting
    # zsh-autosuggestions

    # needed shi
    gcc
    git
    piper
    openrgb
    ntfs3g

    # gnome shi
    # gnomeExtensions
    
    obs-studio
    # power-profiles-daemon
  ];


  # services.qemuGuest.enable=true;

  
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";

}
