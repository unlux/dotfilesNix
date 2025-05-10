{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # ../modules/system/kvm.nix
    # ../modules/system/nvidia.nix
    ../modules/system/pipewire.nix
    ../modules/system/xserver.nix
    ../modules/system/zram.nix
    ../modules/networking/default.nix
    ../modules/gnome/default.nix
    ../modules/nix-helpers/default.nix
    ../modules/docker/default.nix
    inputs.nix-flatpak.nixosModules.nix-flatpak

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-pc-ssd

    # home-manager
    # inputs.home-manager.nixosModules.default
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

  services.printing = {
    enable = true;
    drivers = [pkgs.hplipWithPlugin];
  };

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      # useOSProber = true;
      # splashImage = ./peakpx.png;
      # splashmode = "stretch";
      configurationLimit = 30;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = true; # disable (i enabled it) password login
    };
    # openFirewall = true;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # auto-optimise-store = true;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users = {
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
          "video"
        ];
      };
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    # history.extended = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
  };

  # programs.nix-index.enableZshIntegration = true;
  # programs.carapace.enableZshIntegration = true;
  # programs.atuin.enableZshIntegration = true;

  environment.systemPackages = [pkgs.flatpak pkgs.gnome-software];

  services.flatpak = {
    enable = true;
    packages = [
      "com.github.tchx84.Flatseal"
      # "io.github.everestapi.Olympus"
    ];
    overrides = {
      global = {
        # Force Wayland by default
        Context.sockets = [
          "wayland"
          "!x11"
          "!fallback-x11"
        ];
      };
    };
  };

  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.commit-mono
      # commitmonolux
      # customFont
      # pkgs.monolisa-nerdfonts
    ];
  };

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";

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

  # services.qemuGuest.enable=true;
  boot.kernel.sysctl."kernel.sysrq" = 1; #press alt+sysreq+f to trigger oom killer

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
