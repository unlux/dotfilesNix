{...}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    ../modules/home-manager/adb.nix
    # ../modules/flatpak.nix
    # ../modules/tailscale.nix
    ../modules/home-manager/home-packages.nix
    ../modules/home-manager/git.nix
    # ../modules/fonts/default.nix
  ];

  # home-manager.sharedModules = [
  #   {
  #     stylix.targets.xyz.enable = false;
  #   }
  # ];

  home = {
    username = "lux";
    homeDirectory = "/home/lux";
    stateVersion = "23.11";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  };

  # targets.genericLinux.enable = true; # enable this on non-nixos
  nixpkgs.config.allowUnfree = true;

  programs = {
    home-manager = {
      enable = true;
      # backupFileExtension = "backup";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    starship = {
      enable = true;
      # Configuration written to ~/.config/starship.toml
      # settings = {
      # add_newline = false;

      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };

      # package.disabled = true;
      # };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
