{pkgs, ...}: let
  username = "lux";
in {
  imports = [
    ./debloat.nix
    ./extensions.nix
    ./dconf.nix
  ];

  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
      autoSuspend = false;
    };
  };

  services.udev.packages = [pkgs.gnome-settings-daemon];
  programs.dconf.enable = true;
  home-manager.users.${username} = {
    dconf.settings = {
      "org/gnome/shell".favorite-apps = [
        "zen-beta.desktop"
        "code.desktop"
        "legcord.desktop"
      ];
      "org/gnome/desktop/interface" = {
        enable-hot-corners = true;
        clock-show-weekday = true;
        clock-show-date = true;
        font-antialiasing = "rgba";
        color-scheme = "prefer-dark";
        show-battery-percentage = true;
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
        default-zoom-level = "small";
      };
      "org/gnome/desktop/sound"."allow-volume-above-100-percent" = true;
      "org/gnome/desktop/wm/preferences"."resize-with-right-button" = true;
    };
  };

  # gnome quick login crash fix
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.gnome = {
    evolution-data-server.enable = true;
    gnome-keyring.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-software
    dconf-editor
    # kdeconnect
    wl-clipboard
    ddcutil
  ];

  # luxpfp in gnome
  system.activationScripts.script.text = ''
    mkdir -p /var/lib/AccountsService/{icons,users}
    cp /home/lux/.face /var/lib/AccountsService/icons/lux
    echo -e "[User]\nIcon=/var/lib/AccountsService/icons/lux\n" > /var/lib/AccountsService/users/lux

    chown root:root /var/lib/AccountsService/users/lux
    chmod 0600 /var/lib/AccountsService/users/lux

    chown root:root /var/lib/AccountsService/icons/lux
    chmod 0444 /var/lib/AccountsService/icons/lux
  '';
}
