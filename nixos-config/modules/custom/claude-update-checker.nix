{pkgs, ...}: let
  flakePath = "/home/lux/nixos-config";
  claude-update-script = pkgs.writeShellScript "claude-update-checker" ''
    set -euo pipefail

    FLAKE_PATH="${flakePath}"
    LOCK_FILE="$FLAKE_PATH/flake.lock"

    # Get hash before update
    OLD_HASH=$(${pkgs.coreutils}/bin/sha256sum "$LOCK_FILE" | ${pkgs.coreutils}/bin/cut -d' ' -f1)

    # Run flake update for claude-code
    cd "$FLAKE_PATH"
    ${pkgs.nix}/bin/nix flake update claude-code 2>&1 || {
      ${pkgs.libnotify}/bin/notify-send -u critical "Claude Code Update" "Failed to check for updates"
      exit 1
    }

    # Get hash after update
    NEW_HASH=$(${pkgs.coreutils}/bin/sha256sum "$LOCK_FILE" | ${pkgs.coreutils}/bin/cut -d' ' -f1)

    # Compare and notify
    if [ "$OLD_HASH" != "$NEW_HASH" ]; then
      ${pkgs.libnotify}/bin/notify-send -u normal "Claude Code Update" "New version available! Run 'just nhleptupnow' to apply."
    fi
  '';
in {
  systemd.user.services.claude-update-checker = {
    Unit = {
      Description = "Checks for Claude Code flake updates";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${claude-update-script}";
    };
  };

  systemd.user.timers.claude-update-checker = {
    Unit = {
      Description = "Runs Claude Code update checker hourly";
    };
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
      RandomizedDelaySec = "5min";
    };
    Install = {
      WantedBy = ["timers.target"];
    };
  };
}
