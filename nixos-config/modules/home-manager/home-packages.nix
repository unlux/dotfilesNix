{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    cloudflare-warp
    discord
    # discord-ptb
    easyeffects
    # lunarvim
    jdk
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
    # webcord
    # zoom
    # warp-terminal
    # authy
    spotifywm
    qbittorrent
    zoom-us
    lazygit
    lunarvim
    flameshot
    ulauncher
    noisetorch
  ];

}
