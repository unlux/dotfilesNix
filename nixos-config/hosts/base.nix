{...}: {
  imports = [
    ../modules/bootloader/grub.nix
    # ../modules/system/kvm.nix
    ../modules/system/locale.nix
    # ../modules/system/nvidia.nix
    ../modules/system/openssh.nix
    ../modules/system/pipewire.nix
    ../modules/system/xserver.nix
    ../modules/system/zsh.nix
    # ../modules/xfce/default.nix
    # ../modules/system/systemd.nix
    # ../modules/gnome/gnome2.nix
    ../modules/networking/default.nix
    ../modules/gnome/default.nix
    ../modules/nix-helper/default.nix
    ../modules/system/cyber.nix
    ../modules/networking/tailscale.nix
    ../modules/docker/default.nix
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
    };
  };

  # xdg.portal.wlr.enable = true;

  # home-manager = {
  #   extraSpecialArgs = { inherit inputs; };
  #   users = {
  #     lux = import ./home.nix;
  #   };
  # };

  # services.qemuGuest.enable=true;
  boot.kernel.sysctl."kernel.sysrq" = 1; #press alt+sysreq+f to trigger oom killer

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
