{lib, ...}: {
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = lib.mkDefault true;
    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };
    displayManager.gdm.wayland = lib.mkDefault true;
    xkb.layout = "us";
  };
  services.libinput.enable = true;
}
