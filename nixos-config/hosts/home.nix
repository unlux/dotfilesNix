{pkgs, ...}: {
  imports = [
    ../modules/home-manager/home-packages.nix
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
  };

  programs = {
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
