# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs, lib, config, pkgs, hostname, ... }:

{
  imports = [
    ../modules/system/power.nix
    ../modules/system/kvm.nix
    ../modules/system/locale.nix
    ../modules/system/openssh.nix
    ../modules/system/pipewire.nix
    ../modules/system/xserver.nix
    ../modules/system/zsh.nix
    ../modules/system/bluetooth.nix
    ../modules/system/system-packages-leptup.nix
    ../modules/system/zram.nix
    ../modules/networking/default.nix
    # ../modules/bootloader/systemd.nix
    ../modules/bootloader/grub.nix
    ../modules/gnome/default.nix
    ../modules/nix-ld/default.nix
    # ../modules/nvidia/gpuPassthrough.nix
    ../modules/nvidia/default.nix

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-pc-ssd

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
      extraGroups = 
        [ "wheel" "networkmanager" "docker" 
          "qemu-libvirtd" "libvirtd" "kvm" 
          "adbusers" ];
      packages = with pkgs; [
        # user specific pkgs
      ];
    };
  };

  # xdg.portal.wlr.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      lux = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableAllFirmware = true;

  # services.qemuGuest.enable=true;
  
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
