{ pkgs, home-manager, ... }:
let
  username = "lux";
in
{
  imports = [
    ./debloat.nix
    ./extensions.nix
    ./keybindings.nix
    # ./triple-buffering.nix #TODO: fix the hash
  ];

  # ---- Home Configuration ----
  home-manager.users.${username} = {

    gtk = {
      enable = true;
      theme = {
        name = "Dracula";
        package = pkgs.dracula-theme;
      };
      cursorTheme = {
        name = "Dracula-cursors";
        package = pkgs.dracula-theme;
      };

      iconTheme = {
        name = "Dracula";
        package = pkgs.dracula-icon-theme;
      };
    };

    dconf.settings = {

      "org/gnome/shell".favorite-apps = [
        "io.github.zen_browser.zen.desktop"
        "code.desktop"
        "vesktop.desktop"
      ];

      "org/gnome/desktop/interface" = {
        enable-hot-corners = true;
        clock-show-weekday = true;
        clock-show-date = true;
        monospace-font-name = "CommitMono Nerd Font Regular";
        font-antialiasing = "rgba";
        color-scheme = "prefer-dark";
        show-battery-percentage = true;
        gtk-theme = "Dracula";
        cursor-theme = "Dracula-cursors";
        icon-theme = "Dracula";
      };

      "org/gnome/shell/extensions/user-theme" = {
        name = "Dracula";
      };

      "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
      "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
      "org/gnome/desktop/privacy".remember-recent-files = false;
      "org/gnome/desktop/screensaver".lock-enabled = false;
      "org/gnome/desktop/session".idle-delay = 0;
      "org/gnome/mutter".workspaces-only-on-primary = true;

      "org/gnome/settings-daemon/plugins/power" = {
        power-button-action = "nothing";
        # Suspend only on battery power, not while charging.
        sleep-inactive-ac-type = "nothing";
      };

      "org/gtk/gtk4/settings/file-chooser" = {
        show-hidden = true;
        sort-directories-first = true;
        view-type = "list";
      };

      "org/gnome/desktop/sound" = {
        "allow-volume-above-100-percent" = true;
      };
    };
  };

  # ---- System Configuration ----
  services.gnome = {
    evolution-data-server.enable = true;
    gnome-keyring.enable = true;
  };

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    dracula-theme
    dracula-icon-theme
    #    commit-mono
    gnome-tweaks
    dconf-editor
    # kdeconnect
    wl-clipboard
  ];
}
