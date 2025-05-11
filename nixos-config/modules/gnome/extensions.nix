{
  pkgs,
  lib,
  ...
}: let
  username = "lux";
  gnomeExtensionsList = with pkgs; [
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-panel
    # gnomeExtensions.gesture-improvements
    gnomeExtensions.gsconnect
    # gnomeExtensions.gtile
    # gnomeExtensions.rounded-window-corners
    gnomeExtensions.tailscale-status
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.user-themes
    gnomeExtensions.vitals
    # gnomeExtensions.cloudflare-warp-toggle
    gnomeExtensions.auto-select-headset
    gnomeExtensions.media-controls
    gnomeExtensions.system-monitor
    gnomeExtensions.compiz-alike-magic-lamp-effect
    gnomeExtensions.compiz-windows-effect
    # gnomeExtensions.notification-timeout
    #gnomeExtensions.arcmenu
    #gnomeExtensions.burn-my-windows
    # gnomeExtensions.compact-top-bar
    # gnomeExtensions.custom-accent-colors
    # gradience
    # pano
    #gnomeExtensions.paperwm
    # user-themes
    # unblank
  ];
in {
  # ---- Home Configuration ----
  home-manager.users.${username} = {
    home.packages = gnomeExtensionsList;

    dconf.settings = {
      "org/gnome/shell".enabled-extensions = builtins.map (x: x.extensionUuid) (
        lib.filter (p: p ? extensionUuid) gnomeExtensionsList
      );

      # "org/gnome/shell".disabled-extensions = [
      #     "just-perfection-desktop@just-perfection"
      # ];
    };
  };
}
