{
  pkgs,
  config,
  lib,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = true;
    # targets = {
    #   gnome.enable = true;
    #   gtk.enable = true;
    #   console.enable = true;
    #   # btop.enable = true;
    #   # bat.enable = true;
    #   # exa.enable = true;
    #   # fd.enable = true;
    #   # ripgrep.enable = true;
    #   # zoxide.enable = true;
    #   # zsh.enable = true;
    #   # neovim.enable = true;
    #   # ghostty.enable = true;
    #   # mangohud.enable = true;
    #   # nixos.enable = true;
    #   # nushell.enable = true;
    #   plymouth.enable = true;
    #   plymouth.logoAnimated = true;
    #   # tmux.enable = true;
    # };

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";

    # OKSolar (https://meat.io/oksolar)
    base16Scheme = lib.mkForce {
      # Background tones
      base00 = "#002d38"; # Background
      base01 = "#093946"; # Lighter background (status bars)

      # Content tones
      ## TODO(tlater): Fix these colors; they're not completely suited
      ## ATM because solarized considers these "content colors", while
      ## base16 only considers base03 a content color
      base02 = "#5b7279"; # Selection background
      base03 = "#657377"; # Comments, invisbles, line highlighting
      base04 = "#98a8a8"; # Dark foreground
      base05 = "#8faaab"; # Default foreground

      # Background tones
      base06 = "#f1e9d2"; # Light foreground
      base07 = "#fbf7ef"; # Lightest foreground

      # Accent colors
      base08 = "#f23749";
      base09 = "#d56500";
      base0A = "#ac8300";
      base0B = "#819500";
      base0C = "#259d94";
      base0D = "#2b90d8";
      base0E = "#7d80d1";
      base0F = "#dd459d";

      # Emphasis accent - these aren't in the upstream color scheme,
      # but I'm taking the idea from the "emphasis" text color of
      # going with more saturated varaints of the normal accent
      # colors.
      #
      # TODO(tlater): Need to pick better colors here
      base10 = config.stylix.base16Scheme.base01; # Darker background
      base11 = config.stylix.base16Scheme.base00; # Darkest background
      base12 = "#ff0034";
      base13 = "#b48000";
      base14 = "#809600";
      base15 = "#00a297";
      base16 = "#008ff2";
      base17 = "#7873ff";
    };

    # cursor.package = pkgs.apple-cursor;
    # cursor.name = "apple_cursor";
    # cursor = {
    #   name = "Adwaita Cursors";
    #   package = pkgs.adwaita-icon-theme;
    #   size = 14;
    # };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.commit-mono;
        name = "CommitMono Nerd Font Regular";
      };
      serif = {
        name = "vegur";
        package = pkgs.vegur;
      };

      sansSerif = {
        name = "Inter";
        package = pkgs.inter;
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 11;
        desktop = 11;
        popups = 11;
        # terminal = 10;
      };
    };

    polarity = "dark";

    homeManagerIntegration = {
      autoImport = true;
      followSystem = true;
    };

    # image = null;
    # imageScalingMode = "fill";

    # opacity = {
    #   applications = 0.9;
    #   desktop = 0.9;
    #   popups = 0.9;
    #   terminal = 0.9;
    # };

    # override = {};
  };
  # environment.sessionVariables = lib.mkDefault {
  #   QT_QPA_PLATFORM = "wayland";
  #   QT_QPA_PLATFORMTHEME = "qt5ct";
  # };
}
