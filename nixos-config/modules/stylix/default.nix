{
  pkgs,
  lib,
  ...
}: {
  stylix = {
    enable = true;
    targets = {
      gnome.enable = true;
      gtk.enable = true;
      console.enable = true;
      # btop.enable = true;
      # bat.enable = true;
      # exa.enable = true;
      # fd.enable = true;
      # ripgrep.enable = true;
      # zoxide.enable = true;
      # zsh.enable = true;
      # neovim.enable = true;
      # ghostty.enable = true;
      # mangohud.enable = true;
      # nixos.enable = true;
      # nushell.enable = true;
      plymouth.enable = true;
      plymouth.logoAnimated = true;
      # tmux.enable = true;
    };

    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    # cursor.package = pkgs.apple-cursor;
    # cursor.name = "apple_cursor";
    cursor.package = pkgs.qogir-icon-theme;
    cursor.name = "Qogir Cursors";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.commit-mono;
        name = "CommitMono Nerd Font Regular";
      };
      serif = {
        name = "Cantarell";
        package = pkgs.cantarell-fonts;
      };

      sansSerif = {
        name = "Cantarell";
        package = pkgs.cantarell-fonts;
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 12;
        desktop = 10;
        popups = 10;
        terminal = 12;
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
    #   applications = 1.0;
    #   desktop = 1.0;
    #   popups = 1.0;
    #   terminal = 1.0;
    # };

    # override = {};
  };
  # environment.sessionVariables = lib.mkDefault {
  #   QT_QPA_PLATFORM = "wayland";
  #   QT_QPA_PLATFORMTHEME = "qt5ct";
  # };
}
