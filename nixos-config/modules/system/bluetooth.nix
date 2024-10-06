{ ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        ControllerMode = "bredr";
        Experimental = true;
        # IdleTimeout = 30;
      };
    };
    # package = pkgs.bluez;
    # hsphfpd.enable = true;
  };
  # services.blueman.enable=true;
}
