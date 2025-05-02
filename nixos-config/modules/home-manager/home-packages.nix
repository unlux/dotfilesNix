{pkgs, ...}: {
  home.packages = (
    with pkgs; [
      # Browsers
      brave
      ungoogled-chromium

      # Communication
      # discord
      # discord-ptb
      vesktop
      legcord
      telegram-desktop

      # Development
      nodejs_23
      nodePackages.pnpm
      jdk
      bun
      vscode
      bruno
      # lunarvim

      # Databases & Tools
      mongodb-compass
      # sqlite

      # Productivity
      libreoffice-fresh
      # notion-app-enhanced
      # obsidian # electron ded on wayland, use flatpak instaead
      # postman
      # timeshift

      # Media
      obs-studio
      vlc
      # youtube-music
      # spotify

      # Utilities
      syncthingtray
      termius
      qbittorrent
      # zoom-us
      lazygit
      qdirstat
      atuin
      # looking-glass-client
      piper
      # awscli2
      yt-dlp
      restic
      ente-auth

      # Optional/Commented
      # teamviewer
      # turso-cli
      # vscode
      # webcord
      # zoom
      # warp-terminal
      # authy
      # flameshot
      # ulauncher
      # noisetorch
      # space-cadet-pinball
    ]
  );
}
