{...}: let
  username = "lux";
in {
  # ---- Home Configuration ----
  home-manager.users.${username} = {
    dconf.settings = {
      # gnome default Keybinding remapping
      "org/gnome/desktop/wm/keybindings" = {
        # close = ["<Super>w"];
        move-to-monitor-down = "<Super>j";
        # move-to-monitor-left = "disabled";
        # move-to-monitor-right = "disabled";
        move-to-monitor-up = "<Super>k";
        # toggle-message-tray = "disabled";
        # maximize = "disabled";
        # minimize = "disabled";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        command = "ghostty";
        name = "open-terminal";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>e";
        command = "nautilus";
        name = "File Manager";
      };

      # for a keyboard with no dedicated volume keys
      # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      #   binding = "<ctrl><alt>o";
      #   command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
      #   name = "Volume UP";
      # };

      # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      #   binding = "<ctrl><alt>i";
      #   command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      #   name = "Volume Down";
      # };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
        binding = "<Control><Alt><Super>equal";
        command = "ddcutil setvcp 0x10 + 10";
        name = "Monitor Brightness UP";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
        binding = "<Control><Alt><Super>minus";
        command = "ddcutil setvcp 0x10 - 10";
        name = "Monitor Brightness Down";
      };

      # This is necessary for some reason, or the above custom-keybindings don't work.
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          # "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          # "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
        ];
      };

      # "org/gnome/shell/keybindings" = {
      #   # disable any default keybind for the action before a custom keybind is set
      #   show-screenshot-ui = [ "<Shift><Super>s" ];
      # };
      # for when your keybaord does not have a printsc button
    };
  };
}
