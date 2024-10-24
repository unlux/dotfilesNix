{
  lib,
  config,
  pkgs,
  ...
}:

{
  services.xserver = {
    displayManager = {
      lightdm.enable = true;
      defaultSession = "xfce";
    };
    desktopManager.xfce.enable = true;
  };
}
