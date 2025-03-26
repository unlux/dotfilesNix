{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings.features.cdi = true;
    };
    storageDriver = "btrfs";
  };

  # hardware.nvidia-container-toolkit.enable = true;

  environment.systemPackages = [
    pkgs.docker-compose
    # devenv
  ];
}
