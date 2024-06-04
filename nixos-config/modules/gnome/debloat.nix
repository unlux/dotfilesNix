{ config, pkgs, ...}:

{
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
        ])
        ++ (with pkgs.gnome; [
            atomix
            baobab
            eog
            epiphany
            evince
            geary
            gnome-characters
            gnome-contacts
            gnome-font-viewer
            gnome-logs
            gnome-maps
            gnome-music
            hitori
            iagno
            simple-scan
            tali
            totem
            yelp
        ]);
}
