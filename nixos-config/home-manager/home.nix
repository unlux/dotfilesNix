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
    ../modules/flatpak.nix
    ../modules/adb.nix
    # ../modules/nvidia.nix -> needs root access which home-manager doesnt have
    # ../modules/kvm.nix -> needs root access which home-manager doesnt have
    # ../modules/gpuPassthrough.nix -> needs root access which home-manager doesnt have
    # ../modules/dockerRootless.nix -> needs root access which home-manager doesnt have
    ../modules/tailscale.nix


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
    discord
    # discord-ptb
    webcord
    vlc
    vscode
    ungoogled-chromium
    spotify
    snapper-gui
    snapper
    postman
    # warp-terminal
    # obsidian
    notion-app-enhanced
    mongodb-compass
    brave
    # authy
    easyeffects
    telegram-desktop
    termius
    zoom
    obs-studio
    syncthing

    # for lazyvim
    wl-clipboard-rs
    
  ];

  programs = {
    git = {
      enable = true;
      userName = "lakshay choudhary";
      userEmail = "lakshaychoudhary77712@gmail.com";
    };

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

    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";


}
