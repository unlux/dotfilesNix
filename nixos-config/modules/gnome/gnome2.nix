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
  imports = [ 
    ./debloat.nix
    ./extensions.nix
  ];
  # ---- Home Configuration ----
  home-manager.users.${username} = {


    dconf.settings = {
      
      "org/gnome/shell".favorite-apps = [
        "floorp.desktop"
        "virt-manager.desktop"
        "discord.desktop"
      ];

      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;

        #  gtk-theme = {
        #   name = "palenight";
        #   package = pkgs.palenight-theme;
        # };

        ## Clock
        clock-show-weekday = true;
        clock-show-date = true;

        ## Font stuff
        # monospace-font-name = "RobotoMono Nerd Font 10";
        font-antialiasing = "rgba";
      };

      # Keybindings
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

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"          
        ];
      };



      "org/gnome/shell/keybindings" = {
        show-screenshot-ui = [ "<Shift><Super>s" ];
      };

      "org/gnome/desktop/wm/preferences" = {
        # Workspace Indicator panel
        workspace-names = [
          "Browser"
          "Code"
          "Virt"
        ];
        button-layout = "appmenu:minimize,maximize,close";
      };

      "org/gnome/desktop/wm/keybindings" = {
        toggle-message-tray = "disabled";
        close = [ "<Super>w" ];
        # maximize = "disabled";
        # minimize = "disabled";
        move-to-monitor-down = "disabled";
        move-to-monitor-left = "disabled";
        move-to-monitor-right = "disabled";
        move-to-monitor-up = "disabled";
        move-to-workspace-down = "disabled";
        move-to-workspace-up = "disabled";
        move-to-corner-nw = "disabled";
        move-to-corner-ne = "disabled";
        move-to-corner-sw = "disabled";
        move-to-corner-se = "disabled";
        move-to-side-n = "disabled";
        move-to-side-s = "disabled";
        move-to-side-e = "disabled";
        move-to-side-w = "disabled";
        move-to-center = "disabled";
        toggle-maximized = "disabled";
        unmaximize = "disabled";
      };

    #   "org/gnome/shell/extensions/pop-shell" = {
    #     tile-by-default = true;
    #   };

      # Configure blur-my-shell
      "org/gnome/shell/extensions/blur-my-shell" = {
        brightness = 0.85;
        dash-opacity = 0.25;
        sigma = 15; # Sigma means blur amount
        static-blur = true;
      };
      "org/gnome/shell/extensions/blur-my-shell/panel".blur = true;
      "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
        blur = true;
        style-dialogs = 0;
      };

    #   # Set the default window for primary applications
    #   "org/gnome/shell/extensions/auto-move-windows" = {
    #     application-list = [ "firefox.desktop:1" ];
    #   };

    #   # The open applications bar
    #   "org/gnome/shell/extensions/window-list" = {
    #     grouping-mode = "always";
    #     show-on-all-monitors = true;
    #     display-all-workspaces = true;
    #   };

      "org/gnome/shell/extensions/user-theme" = {
        # name = "nordic";
      };
    };
  };

  # ---- System Configuration ----
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
  services.gnome = {
    evolution-data-server.enable = true;
    gnome-keyring.enable = true;
  };

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [ 
    nordic
    gnome.gnome-tweaks
    gnome.dconf-editor
    kdeconnect
    ];
}