{config, ...}: {
  sops.secrets.restic_password = {
    sopsFile = ../../hosts/secrets/secrets.yaml;
    owner = "lux";
    mode = "0400";
    path = "/etc/restic-password";
  };

  sops.secrets.restic_repository_path = {
    sopsFile = ../../hosts/secrets/secrets.yaml;
    owner = "lux";
    mode = "0400";
    path = "/etc/restic-repository-path";
  };

  services.restic.backups = {
    zen = {
      initialize = true;
      user = "lux";
      passwordFile = config.sops.secrets.restic_password.path;
      repositoryFile = config.sops.secrets.restic_repository_path.path;
      paths = [
        "/home/lux/.zen"
      ];
      timerConfig = {
        OnBootSec = "1min";
        Persistent = true;
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 5"
      ];
      # Optionally, add environmentFile or extraEnv if you need more secrets
    };
  };
}
