{
  pkgs,
  home-manager,
  username,
  lib,
  ...
}:
let 
  username = "lux";
in
{
  # ---- Home Configuration ----
  home-manager.users.${username} = {
    dconf.settings = {
      # Keybindings
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>w" ];
        move-to-monitor-down = "disabled";
        move-to-monitor-left = "disabled";
        move-to-monitor-right = "disabled";
        move-to-monitor-up = "disabled";
        move-to-workspace-down = "disabled";
        toggle-message-tray = "disabled";
        # maximize = "disabled";
        # minimize = "disabled";
      };


      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        command = "wezterm";
        name = "open-terminal";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>e";
        command = "nautilus";
        name = "File Manager";
      };

      # This is necessary for some reason, or the above custom-keybindings don't work.
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"          
        ];
      };

      "org/gnome/shell/keybindings" = {
        # disable any default keybind for the action before a custom keybind is set
        # show-screenshot-ui = [ "<Shift><Super>s" ];
      };
    };
  };
}