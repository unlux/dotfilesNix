{ ... }:
{
  services.syncthing = {
    enable = true;
    # dataDir = "/home/lux";
    # configDir = ""
    openDefaultPorts = true;
    systemService = true;
    user = "lux";
    group = "syncthing";
    dataDir = "/home/lux";
  };
}
