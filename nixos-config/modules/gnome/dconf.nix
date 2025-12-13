# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  username,
  lib,
  ...
}: {
  home-manager.users.${username} = _: {
    dconf.settings = {
      "org/gnome/Geary" = {
        migrated-config = true;
      };

      "org/gnome/TextEditor" = {
        style-scheme = "stylix";
      };

      "org/gnome/desktop/app-folders" = {
        folder-children = ["Utilities" "YaST" "Pardus" "cfd19496-468f-4a88-b52b-e550adcd85a3"];
      };

      "org/gnome/desktop/app-folders/folders/Pardus" = {
        categories = ["X-Pardus-Apps"];
        name = "X-Pardus-Apps.directory";
        translate = true;
      };

      "org/gnome/desktop/app-folders/folders/Utilities" = {
        apps = ["org.gnome.Decibels.desktop" "org.gnome.Calculator.desktop" "org.gnome.Calendar.desktop" "org.gnome.clocks.desktop" "org.gnome.Console.desktop" "ca.desrt.dconf-editor.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Extensions.desktop" "org.gnome.FileRoller.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.Evince.desktop" "org.gnome.fonts.desktop" "org.gnome.Usage.desktop" "vinagre.desktop"];
        categories = ["X-GNOME-Utilities"];
        name = "X-GNOME-Utilities.directory";
        translate = true;
      };

      "org/gnome/desktop/app-folders/folders/YaST" = {
        categories = ["X-SuSE-YaST"];
        name = "suse-yast.directory";
        translate = true;
      };

      "org/gnome/desktop/app-folders/folders/cfd19496-468f-4a88-b52b-e550adcd85a3" = {
        apps = ["startcenter.desktop" "base.desktop" "calc.desktop" "draw.desktop" "impress.desktop" "math.desktop" "writer.desktop"];
        name = "Office";
      };

      "org/gnome/desktop/interface" = {
        clock-show-date = true;
        clock-show-weekday = true;
        color-scheme = "prefer-dark";
        document-font-name = "vegur  10";
        enable-hot-corners = true;
        font-antialiasing = "rgba";
        font-name = "Inter 11";
        gtk-theme = "adw-gtk3";
        monospace-font-name = "CommitMono Nerd Font Regular 11";
        show-battery-percentage = true;
      };

      "org/gnome/desktop/peripherals/keyboard".numlock-state = true;
      "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
      "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
      "org/gnome/desktop/privacy".remember-recent-files = false;
      "org/gnome/desktop/screensaver".lock-enabled = false;
      "org/gnome/desktop/session".idle-delay = 0;
      "org/gnome/desktop/sound".allow-volume-above-100-percent = true;

      "org/gnome/desktop/wm/keybindings" = {
        move-to-monitor-down = "<Super>j";
        move-to-monitor-up = "<Super>k";
        switch-applications = [];
        switch-applications-backward = [];
        switch-windows = ["<Alt>Tab"];
        switch-windows-backward = ["<Shift><Alt>Tab"];
      };

      "org/gnome/desktop/wm/preferences" = {
        resize-with-right-button = true;
      };

      "org/gnome/eog/view" = lib.mkDefault {
        background-color = "#191724";
      };

      "org/gnome/mutter" = {
        workspaces-only-on-primary = false;
        experimental-features = ["variable-refresh-rate"];
      };

      "org/gnome/nautilus/list-view" = {
        default-zoom-level = "small";
        use-tree-view = true;
      };

      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "list-view";
        migrated-gtk-settings = true;
        search-filter-time-type = "last_modified";
      };

      "org/gnome/nautilus/window-state" = {
        initial-size = [900 506];
        initial-size-file-chooser = [900 506];
        maximized = false;
      };

      "org/gnome/nm-applet/eap/01c98a7c-efd9-48d8-b6e7-dc0c90a34753" = {
        ignore-ca-cert = false;
        ignore-phase2-ca-cert = false;
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = false;
        night-light-schedule-automatic = false;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"];
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
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
        binding = "<Super>1";
        command = "nvidia-offload zen";
        name = "NVIDIA Offload Zen";
      };

      "org/gnome/settings-daemon/plugins/power" = {
        power-button-action = "nothing";
        sleep-inactive-ac-type = "nothing";
      };

      "org/gnome/shell" = {
        favorite-apps = ["zen-twilight.desktop" "code.desktop" "legcord.desktop"];
        last-selected-power-profile = "performance";
        welcome-dialog-last-shown-version = "46.2";
      };

      "org/gnome/shell/extensions/alphabetical-app-grid" = {
        folder-order-position = "start";
      };

      "org/gnome/shell/extensions/blur-my-shell" = {
        settings-version = 2;
      };

      "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
        brightness = 0.6;
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blur = true;
        dynamic-opacity = false;
        sigma = 100;
        whitelist = ["org.gnome.Extensions" "com.mitchellh.ghostty" "org.gnome.Nautilus" "code"];
      };

      "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
        blur = true;
        brightness = 0.6;
        pipeline = "pipeline_default_rounded";
        sigma = 30;
        static-blur = true;
        style-dash-to-dock = 0;
      };

      "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/overview" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        brightness = 0.6;
        pipeline = "pipeline_default";
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/window-list" = {
        brightness = 0.6;
        sigma = 30;
      };

      "org/gnome/shell/extensions/com/github/hermes83/compiz-alike-magic-lamp-effect" = {
        duration = 223.0;
        x-tiles = 50.0;
        y-tiles = 50.0;
      };

      "org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect" = {
        mass = 80.0;
        resize-effect = false;
        speedup-factor-divider = 6.0;
        spring-k = 2.4;
      };

      "org/gnome/shell/extensions/dash-to-panel" = {
        animate-appicon-hover = true;
        animate-appicon-hover-animation-extent = ''{"RIPPLE":4,"PLANK":4,"SIMPLE":1}'';
        appicon-margin = 0;
        appicon-padding = "4";
        appicon-style = "NORMAL";
        available-monitors = [0];
        dot-position = "TOP";
        extension-version = 68;
        hotkeys-overlay-combo = "TEMPORARILY";
        intellihide = true;
        intellihide-behaviour = "ALL_WINDOWS";
        intellihide-hide-from-windows = true;
        intellihide-only-secondary = false;
        intellihide-show-in-fullscreen = true;
        intellihide-use-pressure = false;
        leftbox-padding = -1;
        multi-monitors = false;
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
        stockgs-keep-top-panel = false;
        stockgs-panelbtn-click-only = false;
        trans-panel-opacity = 0.0;
        trans-use-custom-bg = false;
        trans-use-custom-opacity = true;
        trans-use-dynamic-opacity = true;
        tray-padding = -1;
        window-preview-title-position = "TOP";
      };

      "org/gnome/shell/extensions/display-brightness-ddcutil" = {
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

      "org/gnome/shell/extensions/lockscreen-extension" = {
        background-size-1 = "cover";
        gradient-direction-1 = "none";
        hide-lockscreen-extension-button = true;
      };

      "org/gnome/shell/extensions/mediacontrols" = {
        colored-player-icon = true;
        extension-position = "Center";
        mouse-action-double = "PLAY_PAUSE";
        show-control-icons = false;
        show-player-icon = true;
      };

      "org/gnome/shell/extensions/notification-timeout" = {
        always-normal = false;
      };

      "org/gnome/shell/extensions/quick-settings-resolution-and-refresh-rate" = {
        add-resolution-toggle-menu = false;
      };

      "org/gnome/shell/extensions/system-monitor" = {
        show-cpu = true;
        show-download = true;
        show-memory = true;
        show-swap = true;
        show-upload = true;
      };

      "org/gnome/shell/extensions/user-theme" = {
        name = "Stylix";
      };

      "org/gnome/shell/extensions/vitals" = {
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

      "org/gtk/gtk4/settings/file-chooser" = {
        date-format = "regular";
        default-zoom-level = "small";
        location-mode = "path-bar";
        show-hidden = true;
        sidebar-width = 140;
        sort-column = "name";
        sort-directories-first = true;
        sort-order = "ascending";
        type-format = "category";
        view-type = "list";
        window-size = [900 506];
      };

      "org/gtk/settings/file-chooser" = {
        date-format = "regular";
        location-mode = "path-bar";
        show-hidden = false;
        show-size-column = true;
        show-type-column = true;
        sidebar-width = 175;
        sort-column = "name";
        sort-directories-first = false;
        sort-order = "ascending";
        type-format = "category";
        window-position = [35 32];
        window-size = [1231 692];
      };

      "org/virt-manager/virt-manager/confirm" = {
        forcepoweroff = false;
      };

      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
