# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./base.nix
    ../modules/system/system-packages-leptup.nix
    ../modules/system/kvm.nix
    ../modules/system/power.nix
    # ../modules/system/noisecancel.nix
    ../modules/system/bluetooth.nix
    ../modules/system/zram.nix
    ../modules/nix-alien/default.nix
    ../modules/nvidia/default.nix
    # ../modules/nvidia/gpuPassthrough.nix
    ../modules/gaming/default.nix
    # ../modules/distrobox/default.nix
    # ../modules/prisma/default.nix
    # ../modules/kubernetes/default.nix
    ../modules/iphone/default.nix
    # ../modules/podman/default.nix
    ../modules/flatpak/default.nix
    ../modules/syncthing/default.nix
    # ../modules/opentablet/default.nix
    ../modules/ollama/default.nix
    # ../modules/cloudflare-warp/default.nix
    # ../modules/printing/default.nix
    ../modules/fonts/default.nix
    # ../overlays/default.nix
    # ../modules/plymouth/default.nix
    ../modules/stylix/default.nix
    ../modules/fonts/default.nix
    ../modules/custom/download-sorter.nix

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-pc-ssd

    # home-manager
    inputs.home-manager.nixosModules.default

    ./leptup-hardware.nix
  ];

  # xdg.portal.wlr.enable = true;

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      lux = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  # nushell
  # users.users.lux = {
  #   shell = pkgs.nushell;
  # };

  boot.kernelPackages = pkgs.linuxPackages_6_6; # use 6.6 LTS kernel

  # specialisation.no-leptup-keyboard.configuration = {
  #   boot.kernelParams = lib.mkForce ["i8042.nokbd"];
  # }; # for use with external keyboard

  # gnome quick login crash fix
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  security.sudo-rs.enable = true;

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
