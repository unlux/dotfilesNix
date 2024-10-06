# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs, lib, config, pkgs, hostname, pkgs-stable, ... }:

{
  imports = [
    ./base.nix
    ../modules/system/kvm.nix
    ../modules/system/power.nix
    # ../modules/system/noisecancel.nix
    ../modules/system/bluetooth.nix
    ../modules/system/system-packages-leptup.nix
    ../modules/system/zram.nix
    ../modules/bootloader/grub.nix
    ../modules/gnome/default.nix
    ../modules/nix-ld/default.nix
    # ../modules/nvidia/gpuPassthrough.nix
    ../modules/nvidia/default.nix
    ../modules/gaming/default.nix
    ../modules/prisma/default.nix
    ../modules/kubernetes/default.nix



    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-pc-ssd

    # home-manager
    inputs.home-manager.nixosModules.default

    ./leptup-hardware.nix
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
          "adbusers" "syncthing" ];
      # packages = with pkgs; [
      #   # user specific pkgs
      # ];
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

  # boot.kernelPackages = pkgs.linuxPackages_zen;
  hardware.enableAllFirmware = true;

  # specialisation.no-leptup-keyboard.configuration = {
  #   boot.kernelParams = lib.mkForce ["i8042.nokbd"];
  # }; # for use with external keyboard

  # services.qemuGuest.enable=true;

  services.printing = {
    enable = false;
    drivers = [ pkgs.hplipWithPlugin ];
  };

   hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
   };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
