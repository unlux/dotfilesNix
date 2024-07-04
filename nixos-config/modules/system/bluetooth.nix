{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        ControllerMode = "dual";
        Experimental = true;
        # IdleTimeout = 30;
      };
    };
    # package = pkgs.bluez;
    # hsphfpd.enable = true;
  };
  # services.blueman.enable=true;
}
