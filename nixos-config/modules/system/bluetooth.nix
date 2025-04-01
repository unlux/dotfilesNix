{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    disabledPlugins = [
      "ccp"
    ];
    settings = {
      General = {
        ControllerMode = "bredr"; # Options are "dual", "le", or "bredr"
        Enable = "Source,Sink,Media,Socket"; #https://discourse.nixos.org/t/bluetooth-no-default-controller-available/56062/3
        FastConnectable = false;
        Experimental = true;
        KernelExperimental = "true";
        # IdleTimeout = 30;
        # https://github.com/bluez/bluez/blob/master/src/main.conf
      };
    };
    # package = pkgs.bluez;
    # hsphfpd.enable = true;
  };
  # systemd.services.bluetooth.serviceConfig.ConfigurationDirectoryMode = "755";
  # services.blueman.enable = true;
  hardware.firmware = [pkgs.linux-firmware]; # Include the latest firmware
}
