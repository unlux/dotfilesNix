{...}: {
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      # useOSProber = true;
      # splashImage = ./peakpx.png;
      # splashmode = "stretch";
      configurationLimit = 30;
    };
  };
}
