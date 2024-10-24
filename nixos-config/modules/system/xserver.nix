{ lib, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = lib.mkDefault true;
    displayManager.gdm = lib.mkDefault {
      enable = true;
      wayland = true;
      autoSuspend = false;
    };
    xkb.layout = "us";
  };
  services.libinput.enable = true;
}
