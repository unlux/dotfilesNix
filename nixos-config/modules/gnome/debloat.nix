{
  lib,
  pkgs,
  ...
}: {
  services = {
    # Disable unused GNOME module features.
    avahi.enable = false;
    dleyna-renderer.enable = false;
    dleyna-server.enable = false;
    hardware.bolt.enable = false;
    gnome = {
      evolution-data-server.enable = lib.mkForce false;
      gnome-initial-setup.enable = false;
      gnome-online-accounts.enable = lib.mkForce false;
      # gnome-online-miners.enable = lib.mkForce false; #removed now
      gnome-user-share.enable = false;
      rygel.enable = false;
    };
  };

  environment.gnome.excludePackages =
    (with pkgs; [
      # atomix
      baobab
      # eog
      evince
      # geary
      # gnome-characters
      gnome-connections
      # gnome-contacts
      # gnome-font-viewer
      # gnome-logs
      # gnome-maps
      # gnome-music
      gnome-photos
      gnome-text-editor
      gnome-tour
      gedit
      # hitori
      # iagno
      pkgs.gedit
      simple-scan
      # tali
      # totem
      yelp
      baobab
      eog
      epiphany
      evince
      geary
      gnome-font-viewer
      simple-scan
      # totem
      yelp
      atomix
      gnome-characters
      gnome-contacts
      gnome-logs
      gnome-maps
      gnome-music
      hitori
      iagno
      tali
    ])
    ++ (with pkgs.gnome; [
      #keeping it for memory
      gvfs
    ]);
}
