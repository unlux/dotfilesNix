_: {
  services = {
    libinput.enable = true;
    xserver = {
      # videoDrivers handled by easyNvidia module
      enable = true;
      xkb.layout = "us";
    };
  };
}
