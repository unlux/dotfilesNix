{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # brave
    cloudflare-warp
    # discord
    # discord-ptb
    vesktop
    easyeffects
    lunarvim
    nodejs_22	
    nodePackages.pnpm
    jdk
    mongodb-compass
    notion-app-enhanced
    obs-studio
    # obsidian
    postman
    timeshift 
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
    flameshot
    ulauncher
    noisetorch
    qdirstat
    atuin
    looking-glass-client
    vscode
    piper
    libreoffice-fresh
    youtube-music
  ];

}
