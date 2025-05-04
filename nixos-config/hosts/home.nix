{pkgs, ...}: {
  imports = [
    # ../modules/fonts/default.nix
  ];

  home = {
    username = "lux";
    homeDirectory = "/home/lux";
    stateVersion = "23.11";
  };

  # targets.genericLinux.enable = true; # enable this on non-nixos
  nixpkgs.config.allowUnfree = true;

  programs = {
    home-manager = {
      enable = true;
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

    git = {
      enable = true;
      userName = "lakshay choudhary";
      userEmail = "lakshaychoudhary77712@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        help.autocorrect = "1";
        diff.algorithm = "histogram";
        transfer.fsckObjects = true;
        fetch.fsckObjects = true;
        receive.fsckObjects = true;
        core = {
          excludeFile = "~/.gitignore";
          pager = "delta";
          editor = "nvim";
          autocrlf = "input";
        };
        pull.rebase = true;
        push.autoSetupRemote = true;
        # credential.helper = "store";
        merge = {
          conflictStyle = "diff3";
          tool = "vimdiff";
        };
        rerere = {
          enabled = true;
          autoupdate = true;
        };
      };
    };
  };

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
      zoom
      # warp-terminal
      # authy
      # flameshot
      # ulauncher
      # noisetorch
      # space-cadet-pinball
    ]
  );

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
