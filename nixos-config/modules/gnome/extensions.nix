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
    # user-themes
    # pano
    
    # unblank
    gnomeExtensions.appindicator
	gnomeExtensions.blur-my-shell
	gnomeExtensions.gsconnect
	#gnomeExtensions.burn-my-windows
	gnomeExtensions.clipboard-indicator-2
	# gnomeExtensions.compact-top-bar
	# gnomeExtensions.custom-accent-colors
	# gradience
	gnomeExtensions.gtile
	gnomeExtensions.dash-to-panel
	gnomeExtensions.tray-icons-reloaded
	#gnomeExtensions.arcmenu
	gnomeExtensions.gesture-improvements
	#gnomeExtensions.paperwm
	gnomeExtensions.just-perfection
	gnomeExtensions.rounded-window-corners
	gnomeExtensions.vitals
	gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.user-themes
    gnomeExtensions.tailscale-qs
    gnomeExtensions.tailscale-status
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

      "org/gnome/shell".disabled-extensions = [ 
        "just-perfection-desktop@just-perfection"
      ];
    };
  };
}