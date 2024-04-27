{
  pkgs,
  home-manager,
  username,
  lib,
  ...
}:
let
    username = "lux";
    gnomeExtensionsList = with pkgs; [
        gnomeExtensions.alphabetical-app-grid
        gnomeExtensions.appindicator
        gnomeExtensions.blur-my-shell
        gnomeExtensions.clipboard-indicator-2
        gnomeExtensions.dash-to-panel
        gnomeExtensions.gesture-improvements
        gnomeExtensions.gsconnect
        gnomeExtensions.gtile
        gnomeExtensions.rounded-window-corners
        gnomeExtensions.tailscale-qs
        gnomeExtensions.tailscale-status
        gnomeExtensions.tray-icons-reloaded
        gnomeExtensions.user-themes
        gnomeExtensions.vitals
        gnomeExtensions.cloudflare-warp-toggle

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
in
{
    # ---- Home Configuration ----
    home-manager.users.${username} = {

        home.packages = gnomeExtensionsList;

        dconf.settings = {
            "org/gnome/shell".enabled-extensions =
                builtins.map
                    (x: x.extensionUuid)
                    (lib.filter (p: p ? extensionUuid) gnomeExtensionsList);

            # "org/gnome/shell".disabled-extensions = [ 
            #     "just-perfection-desktop@just-perfection"
            # ];
        };
    };
}