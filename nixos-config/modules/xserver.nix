{ config, pkgs, ... }:

{
    services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
      autoSuspend = false;
    };
    xkb.layout = "us";
    libinput.enable = true;
  };
}