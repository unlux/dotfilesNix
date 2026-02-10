#!/usr/bin/env bash
#
# zen-restore — Restore Zen browser profile from Restic backups
#
# Reads Restic credentials from the same SOPS-managed secrets used by
# the zen-autobackup systemd service (see modules/custom/zen-autobackup.nix).
#
# Prerequisites:
#   - restic installed (included in system packages via zen-autobackup module)
#   - SOPS secrets deployed at /etc/restic-password and /etc/restic-repository-path
#   - sudo access (secrets are root-owned)
#
# Usage:
#   zen-restore list              Show all available Zen snapshots
#   zen-restore <snapshot-id>     Restore a snapshot (short IDs work, e.g. 3534d7bb)
#
# Restore flow:
#   1. Kills Zen browser if running (SIGTERM, then SIGKILL after 2s)
#   2. Restores snapshot to /tmp/zen-restore for inspection
#   3. Prompts for confirmation before replacing ~/.zen
#   4. Moves current ~/.zen to ~/.zen.broken.<timestamp> as safety net
#   5. Copies restored profile into ~/.zen and cleans up temp dir
#
set -euo pipefail

export RESTIC_PASSWORD_FILE="/etc/restic-password"
export RESTIC_REPOSITORY=$(sudo cat /etc/restic-repository-path)

RESTORE_DIR="/tmp/zen-restore"
ZEN_DIR="$HOME/.zen"

usage() {
    echo "Usage: zen-restore [list | <snapshot-id>]"
    echo ""
    echo "  list              List available Zen browser snapshots"
    echo "  <snapshot-id>     Restore a specific snapshot (short ID is fine)"
    exit 1
}

list_snapshots() {
    sudo -E restic snapshots --tag zen-browser
}

restore_snapshot() {
    local snapshot_id="$1"

    # Kill Zen if running
    if pgrep -f zen-browser > /dev/null 2>&1; then
        echo "Killing Zen browser..."
        pkill -TERM -f zen-browser || true
        sleep 2
        pkill -9 -f zen-browser 2>/dev/null || true
    fi

    # Clean up any previous restore attempt
    rm -rf "$RESTORE_DIR"

    echo "Restoring snapshot $snapshot_id to $RESTORE_DIR..."
    sudo -E restic restore "$snapshot_id" --target "$RESTORE_DIR"

    # Verify restore
    if [ ! -d "$RESTORE_DIR/home/lux/.zen" ]; then
        echo "ERROR: Restore failed — .zen directory not found in snapshot"
        exit 1
    fi

    echo ""
    echo "Restored contents:"
    ls "$RESTORE_DIR/home/lux/.zen/"
    echo ""
    read -rp "Replace current .zen with this restore? [y/N] " confirm

    if [[ "$confirm" != [yY] ]]; then
        echo "Aborted. Restored data is still at $RESTORE_DIR"
        exit 0
    fi

    # Back up current broken state
    if [ -d "$ZEN_DIR" ]; then
        local backup="$ZEN_DIR.broken.$(date +%s)"
        echo "Backing up current .zen to $backup"
        mv "$ZEN_DIR" "$backup"
    fi

    # Move restored profile into place
    cp -a "$RESTORE_DIR/home/lux/.zen" "$ZEN_DIR"

    # Clean up
    rm -rf "$RESTORE_DIR"

    echo "Done. Zen profile restored from snapshot $snapshot_id"
}

[[ $# -lt 1 ]] && usage

case "$1" in
    list) list_snapshots ;;
    -h|--help) usage ;;
    *) restore_snapshot "$1" ;;
esac
