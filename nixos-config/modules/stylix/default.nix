{
  pkgs,
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

    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
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
