{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    cloudflare-warp
    discord
    vesktop
    # discord-ptb
    easyeffects
    # lunarvim
    nodejs_22	
    nodePackages.pnpm
    jdk
    mongodb-compass
    notion-app-enhanced
    obs-studio
    # obsidian
    postman
    snapper
    snapper-gui
    # spotify
    sqlite
    syncthing
    teamviewer
    telegram-desktop
    termius
    turso-cli
    # ungoogled-chromium
    vlc
    # vscode
    # webcord
    # zoom
    # warp-terminal
    # authy
    spotify
    qbittorrent
    zoom-us
    lazygit
    lunarvim
    flameshot
    ulauncher
    noisetorch
    qdirstat
    atuin
    looking-glass-client
    vscode
    openrgb
    piper
    libreoffice-fresh

  ];

}
