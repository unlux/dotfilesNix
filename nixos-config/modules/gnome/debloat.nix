{
  lib,
  pkgs,
  ...
}: {
  services = {
    # Disable unused GNOME module features
    avahi.enable = lib.mkForce false;
    dleyna.enable = lib.mkForce false;
    hardware.bolt.enable = lib.mkForce false;
    gnome = {
      evolution-data-server.enable = lib.mkForce false;
      gnome-initial-setup.enable = lib.mkForce false;
      gnome-online-accounts.enable = lib.mkForce false;
      gnome-user-share.enable = lib.mkForce false;
      rygel.enable = lib.mkForce false;
    };
  };

  environment.gnome.excludePackages = with pkgs;
    [
      atomix
      baobab
      eog
      epiphany
      evince
      geary
      gnome-characters
      gnome-connections
      gnome-contacts
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-photos
      gnome-text-editor
      gnome-tour
      gedit
      hitori
      iagno
      simple-scan
      tali
      totem
      yelp
    ]
    ++ (with pkgs.gnome; [
      ]);
}
