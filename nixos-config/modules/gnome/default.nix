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

  # Necessary for opening links in gnome under certain conditions
  services.gvfs.enable = true;

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
