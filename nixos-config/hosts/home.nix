{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # ../modules/fonts/default.nix
    inputs.zen-browser.homeModules.beta
  ];

  home = {
    username = "lux";
    homeDirectory = "/home/lux";
    stateVersion = "23.11";
  };

  # targets.genericLinux.enable = true; # enable this on non-nixos
  # NOTE: nixpkgs settings are managed at the system level (see hosts/base.nix)

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
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐 ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };
      };
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
        # pull = {
        #   # default = current;
        #   rebase = true;
        # };
        push = {
          autoSetupRemote = true;
          followTags = true;
          # default = current;
        };
        # credential.helper = "store";
        # merge = {
        #   conflictStyle = "diff3";
        #   tool = "vimdiff";
        # };
        # rerere = {
        #   enabled = true;
        #   autoupdate = true;
        # };
        status = {
          branch = true;
          showStash = true;
          # showUntrackedFiles = true;
        };
      };
    };

    carapace = {
      enable = true;
      # enableNushellIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    zen-browser = {
      enable = true;
      policies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        # find more options here: https://mozilla.github.io/policy-templates/
      };
    };
  };

  home.packages = with pkgs; [
    # inputs.zen-browser.packages."${system}".default
    # Browsers
    brave
    ungoogled-chromium
    # Communication
    # discord
    # discord-ptb
    # vesktop
    # signal-desktop
    legcord
    telegram-desktop

    # Development
    nodejs_22
    corepack_22
    jdk
    bun
    vscode
    code-cursor
    windsurf
    # bruno
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
    # obs-studio
    vlc
    # youtube-music
    # spotify

    # Utilities
    delta
    syncthingtray
    # termius
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
    # supabase-cli
    # Optional/Commented
    # teamviewer
    # turso-cli
    # webcord
    # warp-terminal
    # authy
    # flameshot
    # ulauncher
    # noisetorch
    # space-cadet-pinball
    easyeffects

    libnotify
    # kiro-fhs
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
