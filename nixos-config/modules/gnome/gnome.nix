{ config, pkgs, ... }:



{
# nixpkgs.overlays = [
#   (final: prev: {
#     gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
#       mutter = gnomePrev.mutter.overrideAttrs ( old: {
#         src = pkgs.fetchgit {
#           url = "https://gitlab.gnome.org/vanvugt/mutter.git";
#           # GNOME 45: triple-buffering-v4-45
#           rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
#           sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
#         };
#       } );
#     });
#   })
# ];


environment.gnome.excludePackages = with pkgs.gnome; [
	baobab 
	# cheese 
	eog 
	epiphany
	pkgs.gedit
	simple-scan
	totem
	yelp
	evince
	geary
	seahorse
	gnome-characters 
	gnome-contacts
	gnome-font-viewer
	gnome-logs
	gnome-maps
	gnome-music
	# gnome-system-monitor
	# gnome-terminal
	pkgs.gnome-connections
	pkgs.gnome-text-editor
	pkgs.gnome-tour
	# pkgs.gnome-photos
];

environment.systemPackages = with pkgs; [
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
	gnome.gnome-tweaks
	gnome.dconf-editor
	kdeconnect
];

services.gnome.gnome-remote-desktop.enable = false;
services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];




}
