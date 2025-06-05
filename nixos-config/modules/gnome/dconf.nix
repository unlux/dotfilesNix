# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{username, ...}: {
  home-manager.users.${username} = {...}: {
    dconf.settings = {
      "alphabetical-app-grid" = {
        folder-order-position = "start";
      };

      "com/github/hermes83/compiz-windows-effect" = {
        mass = 80.0;
        resize-effect = false;
        speedup-factor-divider = 6.0;
        spring-k = 2.4;
      };

      "dash-to-panel" = {
        animate-appicon-hover = true;
        appicon-margin = 0;
        appicon-padding = "4";
        appicon-style = "NORMAL";
        available-monitors = [0];
        dot-position = "TOP";
        extension-version = 68;
        hotkeys-overlay-combo = "TEMPORARILY";
        intellihide = false;
        intellihide-hide-from-windows = true;
        intellihide-only-secondary = false;
        intellihide-show-in-fullscreen = true;
        intellihide-use-pressure = false;
        leftbox-padding = -1;
        multi-monitors = true;
        panel-anchors = ''
          {"AUO-0x00000000":"MIDDLE","ACR-4429030723W01":"MIDDLE"}
        '';
        panel-element-positions = ''
          {"AUO-0x00000000":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"dateMenu","visible":true,"position":"centered"},{"element":"centerBox","visible":true,"position":"centered"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}],"ACR-4429030723W01":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"dateMenu","visible":true,"position":"centered"},{"element":"centerBox","visible":true,"position":"centered"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}
        '';
        panel-element-positions-monitors-sync = true;
        panel-lengths = ''
          {"AUO-0x00000000":100}
        '';
        panel-positions = ''
          {"AUO-0x00000000":"TOP","ACR-4429030723W01":"TOP"}
        '';
        panel-sizes = ''
          {"AUO-0x00000000":25,"ACR-4429030723W01":25}
        '';
        prefs-opened = false;
        primary-monitor = "ACR-4429030723W01";
        status-icon-padding = -1;
        trans-panel-opacity = 0.4;
        trans-use-custom-bg = false;
        trans-use-custom-opacity = true;
        trans-use-dynamic-opacity = true;
        tray-padding = -1;
        window-preview-title-position = "TOP";
      };

      "display-brightness-ddcutil" = {
        button-location = 0;
        ddcutil-binary-path = "/usr/bin/ddcutil";
        ddcutil-queue-ms = 130.0;
        ddcutil-sleep-multiplier = 40.0;
        decrease-brightness-shortcut = ["<Control>XF86MonBrightnessDown"];
        hide-system-indicator = true;
        increase-brightness-shortcut = ["<Control>XF86MonBrightnessUp"];
        position-system-menu = 3.0;
        show-all-slider = false;
        show-value-label = true;
        step-change-keyboard = 2.0;
      };

      "gsconnect" = {
        discoverable = true;
        enabled = true;
        id = "392dd798-c242-46e5-a856-b5f3fc31b295";
        name = "leptup";
      };

      "lockscreen-extension" = {
        background-size-1 = "cover";
        gradient-direction-1 = "none";
        hide-lockscreen-extension-button = true;
      };

      "mediacontrols" = {
        colored-player-icon = true;
        extension-position = "Center";
        mouse-action-double = "PLAY_PAUSE";
        show-control-icons = false;
        show-player-icon = true;
      };

      "ncom/github/hermes83/compiz-alike-magic-lamp-effect" = {
        duration = 223.0;
        x-tiles = 50.0;
        y-tiles = 50.0;
      };

      "notification-timeout" = {
        always-normal = false;
      };

      "quick-settings-resolution-and-refresh-rate" = {
        add-resolution-toggle-menu = false;
      };

      "system-monitor" = {
        show-cpu = true;
        show-download = true;
        show-memory = true;
        show-swap = true;
        show-upload = true;
      };

      "user-theme" = {
        name = "Stylix";
      };

      "vitals" = {
        battery-slot = 1;
        hot-sensors = ["_battery_rate_"];
        icon-style = 1;
        position-in-panel = 4;
        show-battery = true;
        show-fan = false;
        show-memory = false;
        show-network = false;
        show-processor = false;
        show-storage = false;
        show-system = false;
        show-temperature = false;
        show-voltage = false;
        update-time = 2;
      };
    };
  };
}
