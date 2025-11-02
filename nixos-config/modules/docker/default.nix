{
  pkgs-stable,
  pkgs,
  ...
}: {
  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      enableOnBoot = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon.settings = {
          features.cdi = true;
          dns = ["8.8.8.8" "8.8.4.4"];
        };
      };
      storageDriver = "btrfs";
      daemon.settings = {
        dns = ["8.8.8.8" "8.8.4.4"];
        log-driver = "json-file";
      };
    };
  };

  # hardware.nvidia-container-toolkit.enable = true;

  environment.systemPackages = [
    pkgs-stable.docker-compose
    pkgs.slirp4netns # Required for rootless Docker networking
    # devenv
  ];
}
# PODMAN
# # https://nixos.wiki/wiki/Podman
# {pkgs, ...}: {
#   # Enable common container config files in /etc/containers
#   virtualisation.containers.enable = true;
#   virtualisation = {
#     podman = {
#       enable = true;
#       # Create a `docker` alias for podman, to use it as a drop-in replacement
#       dockerCompat = true;
#       # Required for containers under podman-compose to be able to talk to each other.
#       defaultNetwork.settings.dns_enabled = true;
#     };
#   };
#   # Useful other development tools
#   environment.systemPackages = with pkgs; [
#     dive # look into docker image layers
#     podman-tui # status of containers in the terminal
#     docker-compose # start group of containers for dev
#     #podman-compose # start group of containers for dev
#   ];
# }
# # Run Podman containers as systemd services
# # {
# #   virtualisation.oci-containers.backend = "podman";
# #   virtualisation.oci-containers.containers = {
# #     container-name = {
# #       image = "container-image";
# #       autoStart = true;
# #       ports = [ "127.0.0.1:1234:1234" ];
# #     };
# #   };
# # }

