{...}: {
  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
      autoSuspend = false;
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
  };
  services.libinput.enable = true;
}
