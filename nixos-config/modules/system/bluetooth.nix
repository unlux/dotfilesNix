{ config, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        ControllerMode = "dual";
        Experimental = true;
        IdleTimeout = 30;
      };
    };
    # hsphfpd.enable = true;
  };
}
