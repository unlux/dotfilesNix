{...}: {
  services = {
    libinput.enable = true;
    xserver = {
      videoDrivers = ["amdgpu"];
      enable = true;
      xkb.layout = "us";
    };
  };
}
