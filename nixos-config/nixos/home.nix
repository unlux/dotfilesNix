{ inputs, outputs, lib, config, pkgs, ... }: 

{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ../modules/adb.nix
    # ../modules/dockerRootless.nix -> needs root access which home-manager doesnt have
    ../modules/flatpak.nix
    # ../modules/gpuPassthrough.nix -> needs root access which home-manager doesnt have
    # ../modules/kvm.nix -> needs root access which home-manager doesnt have
    # ../modules/nixHelper.nix
    # ../modules/nvidia.nix -> needs root access which home-manager doesnt have
    # ../modules/tailscale.nix
  ];

  home = {
    username = "lux";
    homeDirectory = "/home/lux";
    stateVersion = "23.11";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  };

  # targets.genericLinux.enable = true; # enable this on non-nixos
  nixpkgs.config.allowUnfree = true;  

  home.packages = with pkgs; [
    brave
    cloudflare-warp
    discord
    # discord-ptb
    easyeffects
    # lunarvim
    mongodb-compass
    notion-app-enhanced
    obs-studio
    # obsidian
    postman
    ripgrep
    snapper
    snapper-gui
    # spotify
    sqlite
    syncthing
    teamviewer
    telegram-desktop
    termius
    turso-cli
    ungoogled-chromium
    vlc
    # vscode
    webcord
    # zoom
    # warp-terminal
    # authy
    spotifywm
  ];

  programs = {
    git = {
      enable = true;
      userName = "lakshay choudhary";
      userEmail = "lakshaychoudhary77712@gmail.com";
    };

    home-manager.enable = true;

    # nh = {
    #   enable = true;
    #   # clean.enable = true;
    #   # clean.extraArgs = "--keep-since 4d --keep 3";
    #   # flake = "/home/lux/nixos-config";
    # };

    starship = {
      enable = true;
      # custom settings
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };  
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
