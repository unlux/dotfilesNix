# DISKO_INSTALL.md

Complete guide to installing NixOS on this system using Disko for declarative disk partitioning and formatting.

## What is Disko?

Disko is a NixOS tool that provides **declarative disk partitioning and formatting**. Instead of manually running `fdisk`, `mkfs`, etc., you describe your desired disk layout in Nix, and Disko automatically creates it.

**Benefits:**
- Reproducible disk layouts across multiple machines
- Version-controlled partition schemes
- Easy to modify and test without manual commands
- Self-documenting infrastructure
- Can be used during installation via live USB

## Current System Configuration

This repository's disko config (`hosts/disk.nix`) specifies:

- **Disk**: `/dev/nvme0n1` (NVMe SSD)
- **Partitioning**: GPT (GUID Partition Table)
- **EFI Boot**: 2 GB FAT32 partition mounted at `/boot` (ample space for kernel configs and generations)
- **Root Filesystem**: Btrfs with zstd:3 compression (all space except last 150GB)
- **Windows Reserve**: 150 GB unpartitioned space at the end for future Windows installation
- **Subvolumes** (for better organization and snapshotting):
  - `@` → `/` (root filesystem)
  - `@home` → `/home` (user home directories)
  - `@nix` → `/nix` (Nix store - separate for optimization)
  - `@var` → `/var` (logs, caches, databases)
  - `@tmp` → `/tmp` (temporary files)

**Mount Options (all subvolumes):**
- `compress=zstd:3` - zstd compression at level 3 (good balance of speed/ratio)
- `relatime` - Reduced inode access time updates (better performance)
- `discard=async` - Asynchronous TRIM for SSD health

## Installation Steps

### 1. Boot NixOS Live USB

1. Download NixOS ISO: https://nixos.org/download/
2. Create bootable USB:
   ```bash
   # On Linux:
   sudo dd if=nixos-minimal-x.y.z-x86_64-linux.iso of=/dev/sdX bs=4M status=progress oflag=sync

   # On macOS:
   dd if=nixos-minimal-x.y.z-x86_64-linux.iso of=/dev/rdiskX bs=4m
   ```
3. Boot from USB (press F2/F12/DEL depending on your laptop BIOS)
4. Wait for NixOS live system to reach the root prompt

### 2. Connect to Network

```bash
# For WiFi (if available)
nmcli device wifi list
nmcli device wifi connect "SSID" password "PASSWORD"

# Verify internet
ping 8.8.8.8
```

### 3. Clone This Repository

```bash
cd /tmp
nix-shell -p git
git clone https://github.com/yourusername/nixos-config
cd nixos-config
```

### 4. Verify Disk Configuration

Before running disko, verify the target disk:

```bash
# List available disks
lsblk

# If using a different disk than /dev/nvme0n1, edit flake.nix:
# Change the _module.args.disks line in the leptup nixosConfiguration
```

**⚠️ WARNING**: The next step will **ERASE** the entire disk. Ensure you're targeting the correct disk!

### 5. Run Disko to Format and Partition

```bash
# Create partitions and mount filesystems according to disk.nix
sudo nix run github:nix-community/disko -- --mode disko ./hosts/disk.nix

# Or, if using a different disk:
sudo nix run github:nix-community/disko -- --mode disko --arg disks '"/dev/sda"' ./hosts/disk.nix
```

**What this does:**
- Wipes the disk completely
- Creates EFI partition (2 GB)
- Creates Btrfs filesystem with zstd compression for remaining space (minus 150 GB)
- Creates all subvolumes (@, @home, @nix, @var, @tmp)
- Leaves 150 GB unpartitioned at the end for Windows dual-boot
- Mounts everything to `/mnt`

**Output should look like:**
```
✓ Partitions created
✓ Filesystems formatted
✓ Subvolumes created
✓ Filesystems mounted
```

### 6. Generate Hardware Configuration (Optional)

While disko handles disk partitioning, you still need hardware-specific details (CPU microcode, kernel modules, etc.):

```bash
sudo nixos-generate-config --root /mnt
```

This creates `/mnt/etc/nixos/hardware-configuration.nix`. However, for this repository, we use `hosts/leptup-hardware.nix` which should work for similar hardware. Update it if needed.

### 7. Install NixOS with Flakes

```bash
cd /tmp/nixos-config

# Generate flake.lock if it doesn't exist
nix flake update

# Install the system
sudo nixos-install --flake '.#leptup' --root /mnt
```

**What this does:**
- Evaluates flake.nix with disko configuration
- Builds all system packages
- Installs bootloader (GRUB for EFI)
- Copies system to `/mnt`
- Generates NixOS generation

### 8. Reboot

```bash
sudo reboot
```

Remove the USB stick when prompted. The system should boot into NixOS with your configuration applied.

### 9. Post-Installation Setup

Once booted:

```bash
# Set up home-manager (for user environment)
home-manager switch --flake '.#lux@leptup'

# Or use the Just command:
just home-switch
```

## Advanced: Using Disko on Existing System

If you want to change disk partitioning on an already-installed system:

```bash
# DANGER: This will erase all data!
sudo nix run github:nix-community/disko -- --mode disko ./hosts/disk.nix
```

This is useful for:
- Repartitioning (if you want to add/remove subvolumes)
- Testing new layouts before committing
- Migrating to different disk devices

## Customizing Disko for Different Hardware

### Using a Different Disk Device

Edit `flake.nix`:

```nix
{
  _module.args.disks = ["/dev/sda"];  # Change from nvme0n1 to sda
}
```

Or pass it as argument:

```bash
sudo nix run github:nix-community/disko -- --mode disko --arg disks '"/dev/sda"' ./hosts/disk.nix
```

### Adjusting Boot Partition Size

The EFI boot partition is currently set to 2 GB, which is ample for storing kernel configurations, boot images, and multiple NixOS generations. If you need more or less space:

Edit `hosts/disk.nix`:

```nix
ESP = {
  size = "3G";  # Adjust from current 2G as needed
  ...
};
```

### Adjusting Windows Reserve Space

To change the 150 GB reserved space for Windows, edit the root partition size:

```nix
root = {
  size = "-200G";  # Change from -150G to -200G for more Linux space
  ...
};
```

### Changing Compression Level

Edit `hosts/disk.nix`:

```nix
"@" = {
  mountOptions = [
    "compress=zstd:1"  # Change from zstd:3 (1=fastest, 15=best compression)
    ...
  ];
};
```

**Compression levels:**
- `1-3`: Fast compression (suitable for fast SSDs)
- `4-7`: Balanced (default recommended range)
- `8-15`: High compression (slower, better ratio)

### Adding/Removing Subvolumes

Edit `hosts/disk.nix` to add new subvolumes:

```nix
"@custom" = {
  mountpoint = "/custom/path";
  mountOptions = [
    "compress=zstd:3"
    "relatime"
    "discard=async"
  ];
};
```

Then mount them in system config:

```nix
# In hosts/base.nix or modules/
fileSystems."/custom/path" = lib.mkDefault {
  device = "/dev/disk/by-uuid/<YOUR-UUID>";
  fsType = "btrfs";
  options = [ "subvol=@custom" "compress=zstd:3" "relatime" "discard=async" ];
};
```

## Btrfs Subvolumes Explained

Why separate subvolumes?

| Subvolume | Purpose | Why Separate |
|-----------|---------|---|
| `@` | System files (/etc, /usr, /opt) | Easy to snapshot OS without user data |
| `@home` | User home directories | Frequent snapshots, different retention policies |
| `@nix` | Nix store | Deduplication, separate GC policy, rarely snapshot |
| `@var` | Logs, caches, databases | High write activity, isolate I/O |
| `@tmp` | Temporary files | Very high I/O, isolate from others |

**Benefits:**
- **Snapshots**: Snapshot `@home` without affecting `/nix`
- **Backups**: Back up `@home` with different strategy than `@`
- **Cleanup**: Run `btrfs subvolume delete` on specific volumes
- **Performance**: Isolate high-activity volumes (var, tmp)

## Troubleshooting

### "Device already exists" Error

Your disk might have existing partitions. To force disko to overwrite:

```bash
# Already in disk.nix with extraArgs = ["-f"]
# But if needed, you can manually clear:
sudo wipefs -a /dev/nvme0n1
sudo nix run github:nix-community/disko -- --mode disko ./hosts/disk.nix
```

### "No space left on device"

Btrfs filesystem is full. This can happen if:
- Nix store grew too large
- Logs filled the disk

Solution:

```bash
# Run garbage collection
sudo nix-collect-garbage -d

# Or more aggressive:
sudo nix-store --gc --max-freed 10G
```

### Disko Can't Find Target Disk

Verify the disk path:

```bash
# List all disks
lsblk

# Find NVMe disk specifically
nvme list

# Adjust disk path in flake.nix or pass as argument
```

### System Won't Boot After Disko Installation

**Symptoms**: Black screen, GRUB not found, "No bootable device"

**Solutions:**

1. **Boot back into live USB** and check filesystem:
   ```bash
   sudo btrfs filesystem show
   sudo btrfs subvolume list /mnt
   ```

2. **Verify bootloader installed**:
   ```bash
   # Mount and check
   sudo mount /dev/nvme0n1p1 /mnt/boot
   ls -la /mnt/boot/EFI/GRUB/
   ```

3. **Reinstall bootloader**:
   ```bash
   sudo nix run github:nix-community/disko -- --mode disko ./hosts/disk.nix
   sudo nixos-install --flake '.#leptup' --root /mnt
   ```

### After Install, "Unknown filesystem type btrfs"

You may need to update GRUB or enable btrfs module in initrd. Edit `hosts/base.nix`:

```nix
boot.initrd.supportedFilesystems = [ "btrfs" ];
boot.supportedFilesystems = [ "btrfs" ];
```

Then rebuild:

```bash
just nhleptupnow
```

## Monitoring Btrfs Health

After installation, monitor your Btrfs filesystem:

```bash
# View filesystem usage and compression ratio
sudo btrfs filesystem usage /

# Check for errors
sudo btrfs device stats /

# Monitor compression effectiveness
sudo btrfs filesystem df /

# List all subvolumes
sudo btrfs subvolume list /
```

## References

- **Disko**: https://github.com/nix-community/disko
- **Btrfs Wiki**: https://btrfs.readthedocs.io/
- **NixOS Manual - Disko**: https://search.nixos.org/options?query=disko
- **Zstd Compression**: https://facebook.github.io/zstd/

## Quick Reference

| Task | Command |
|------|---------|
| Format disk with disko | `sudo nix run github:nix-community/disko -- --mode disko ./hosts/disk.nix` |
| Install system | `sudo nixos-install --flake '.#leptup' --root /mnt` |
| Check Btrfs health | `sudo btrfs filesystem usage /` |
| List subvolumes | `sudo btrfs subvolume list /` |
| Garbage collect | `sudo nix-collect-garbage -d` |
| Update flake | `just upp` |
| Rebuild system | `just nhleptupnow` |
