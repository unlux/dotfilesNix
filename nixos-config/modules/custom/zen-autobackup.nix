{
  config,
  pkgs,
  ...
}: let
  notify = "${pkgs.libnotify}/bin/notify-send";
  backupScript = pkgs.writeShellScript "zen-backup" ''
    export RESTIC_PASSWORD_FILE="/etc/restic-password"
    export RESTIC_REPOSITORY=$(cat /etc/restic-repository-path)
    export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

    ${notify} -u low -i drive-harddisk "Zen Backup" "Starting backup..."

    # Initialize repo if needed
    ${pkgs.restic}/bin/restic snapshots &>/dev/null || ${pkgs.restic}/bin/restic init

    # Run backup (exclude volatile/regeneratable data)
    if ${pkgs.restic}/bin/restic backup /home/lux/.zen --tag zen-browser \
      --exclude="*/storage/default/*/cache" \
      --exclude="*/storage/temporary" \
      --exclude="*/gmp-widevinecdm" \
      --exclude="*/gmp-gmpopenh264" \
      --exclude="*/datareporting" \
      --exclude="*/crashes" \
      --exclude="*/minidumps" \
      --exclude=".parentlock" \
      --exclude="*.lock"; then
      ${notify} -u low -i emblem-ok "Zen Backup" "Backup completed successfully"
    else
      ${notify} -u critical -i dialog-error "Zen Backup" "Backup failed!"
      exit 1
    fi

    # Prune old snapshots
    ${pkgs.restic}/bin/restic forget \
      --keep-last 50 \
      --keep-daily 14 \
      --keep-weekly 8 \
      --keep-monthly 6 \
      --prune
  '';
in {
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

  environment.systemPackages = [pkgs.libnotify pkgs.restic];

  # Backup on shutdown (kill Zen first, then backup)
  systemd.services.zen-backup-shutdown = {
    description = "Backup Zen browser profile on shutdown";
    wantedBy = ["multi-user.target"];
    # Run before shutdown completes
    before = ["shutdown.target" "reboot.target" "halt.target"];
    # But after we're fully booted (don't run on boot)
    after = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
      # ExecStart does nothing, just marks service as "started"
      ExecStart = "${pkgs.coreutils}/bin/true";
      # ExecStop runs on shutdown - kill Zen then backup
      ExecStop = pkgs.writeShellScript "zen-backup-shutdown" ''
        # Gracefully kill Zen browser
        ${pkgs.util-linux}/bin/runuser -u lux -- ${pkgs.procps}/bin/pkill -TERM -f zen-browser || true
        sleep 2
        # Force kill if still running
        ${pkgs.util-linux}/bin/runuser -u lux -- ${pkgs.procps}/bin/pkill -9 -f zen-browser || true
        sleep 1
        # Run backup as lux user
        ${pkgs.util-linux}/bin/runuser -u lux -- ${backupScript}
      '';
    };
  };
}
