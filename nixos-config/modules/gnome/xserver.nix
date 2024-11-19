# different xserver file for gnome coz 
{ lib, ... }:

{
  imports = [ ../modules/system/xserver.nix ];

  desktopManager.gnome.enable = lib.mkDefault true;
  displayManager.gdm = lib.mkDefault {
    enable = true;
    wayland = true;
    autoSuspend = false;
  };
}
