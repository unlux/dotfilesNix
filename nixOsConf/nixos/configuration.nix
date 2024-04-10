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
    # ./gpuPassthrough.nix

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

  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/vda";
  # boot.loader.grub.useOSProber = true;
  # boot.kernelModules = [
  #  "kvm-amd"
  # ];
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader = {
  efi = {
    canTouchEfiVariables = true;
  };
  grub = {
     enable = true;
     efiSupport = true;
     device = "nodev";
  };
};
  

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

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

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_IN";
  
  i18n.extraLocaleSettings = {
  LC_ADDRESS = "en_IN";
  LC_IDENTIFICATION = "en_IN";
  LC_MEASUREMENT = "en_IN";
  LC_MONETARY = "en_IN";
  LC_NAME = "en_IN";
  LC_NUMERIC = "en_IN";
  LC_PAPER = "en_IN";
  LC_TELEPHONE = "en_IN";
  LC_TIME = "en_IN";
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

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
	        "git"
          "kubectl"
          "helm"
          "docker"
        ];
      };
    };
  };
  users.defaultUserShell = pkgs.zsh;
  
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
    # qdirstat

    # apps
    discord
    discord-ptb
    vlc
    vscode
    ungoogled-chromium
    floorp
    spotify
    snapper-gui
    snapper
    postman
    #warp-terminal
    #obsidian
    #notion-app-enhanced
    mongodb-compass
   	brave
 #	authy
    easyeffects
    telegram-desktop

    # virtualisation shi
    docker
  	virt-manager
    iptables

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
    power-profiles-daemon
    powertop
   	wget
    zoxide
    htop
    ffmpeg
 	# devbox
    iftop
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
  ];


  # services.qemuGuest.enable=true;
  services.supergfxd.enable=true;

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };

  services.tailscale = {
      enable = true;
    };

  # use docker without Root access (Rootless docker)
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  
  virtualisation.libvirtd = {
  enable = true;
  qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = true;
    swtpm.enable = true;
    #ovmf = {
    #  enable = true;
    #  packages = [(pkgs.unstable.OVMF.override {
    #    secureBoot = true;
    #    tpmSupport = true;
    #  }).fd];
    
  };
};


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";

}
