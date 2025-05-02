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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
