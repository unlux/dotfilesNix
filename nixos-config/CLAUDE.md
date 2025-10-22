# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a comprehensive NixOS configuration (dotfiles) using Nix Flakes for a personal laptop system (hostname: `leptup`). It provides declarative, reproducible system and user environment management across desktop environment, development tools, gaming, containerization, and GPU management.

**Primary Tech Stack:**
- **OS**: NixOS (unstable + stable channels)
- **Configuration Language**: Nix (declarative, functional)
- **Build System**: Just (task runner) + nh (Nix helper)
- **Disk Management**: Disko (declarative partitioning + formatting)
- **Filesystem**: Btrfs with zstd compression
- **DE**: GNOME with Wayland
- **GPU**: NVIDIA (proprietary) + AMD iGPU with PRIME offload
- **Package Manager**: Nix (declarative flakes)
- **Secrets**: SOPS-Nix with age encryption
- **Containerization**: Docker (rootless mode)
- **Virtualization**: QEMU/KVM with libvirt

## Codebase Structure

```
nixos-config/
├── flake.nix                  # Main entry point, defines all inputs & outputs
├── flake.lock                 # Pinned dependency versions
├── Justfile                   # Task runner commands for build/deploy/updates
├── hosts/                     # Host-specific configurations
│   ├── base.nix              # Shared system configuration (all hosts)
│   ├── leptup.nix            # Active laptop config (imports base + modules)
│   ├── leptup-hardware.nix   # Laptop hardware config (CPU, GPU, etc)
│   ├── disk.nix              # Disko declarative disk layout (btrfs + zstd, subvolumes)
│   ├── home.nix              # Home-manager user environment (Zsh, Git, IDEs, etc)
│   ├── secrets/
│   │   └── secrets.yaml      # Encrypted secrets (SOPS + age)
│   ├── pc.nix                # Desktop config (commented out)
│   └── pc-hardware.nix       # Desktop hardware config (commented out)
├── modules/                   # 18 reusable NixOS modules
│   ├── system/               # Core system: power (TLP), audio (PipeWire), Bluetooth, X11/Wayland
│   ├── gnome/                # GNOME desktop environment setup
│   ├── easyNvidia/           # GPU management: NVIDIA + AMD PRIME offload, VAAPI
│   ├── stylix/               # Unified theme system (base16 theming)
│   ├── docker/               # Docker containerization (rootless mode)
│   ├── python/               # Python dev env (3.12, Poetry, UV)
│   ├── nix-helpers/          # Dev tools: alejandra, nixpkgs-fmt, nvd, nh, nix-index
│   ├── gaming/               # Gaming: Steam, Proton, GameMode, controller support
│   ├── android/              # Android tools and device support
│   ├── kubernetes/           # Kubernetes tools (kubectl, helm, etc)
│   ├── networking/           # Firewall, DNS, Tailscale, SSH
│   ├── custom/               # Custom automation:
│   │   ├── download-sorter.nix      # Systemd timer: daily Downloads folder organization
│   │   └── zen-autobackup.nix       # Systemd service: encrypted Zen browser backup (Restic)
│   ├── adblock/              # Ad-blocking setup
│   ├── iphone/               # iPhone/iOS device support
│   ├── ollama/               # Ollama LLM support
│   ├── prisma/               # Prisma ORM setup
│   ├── fonts/                # Font configuration
│   └── plymouth/             # Boot splash screen
├── overlays/                  # Custom package modifications
│   └── zen-offload.nix       # Custom Zen browser overlay
└── ref/                       # Reference configurations
    └── mobile-dev.nix.example # Example mobile dev setup
```

## Key Architectural Patterns

### 1. **Module System**
Each subsystem is isolated in a dedicated module under `modules/`. The active host (`leptup.nix`) imports:
- `base.nix` (shared config)
- Individual modules via `imports = [...]` pattern
- Special args propagated through `specialArgs` for access to `hostname`, `username`, `pkgs`, etc.

### 2. **Dual Channel Package Management**
- `pkgs`: NixOS unstable (latest versions)
- `pkgs-stable`: NixOS stable (stable versions)
- Allows pinning specific packages to stable when needed

### 3. **Hardware Awareness**
Separate `*-hardware.nix` files handle:
- CPU details (AMD Ryzen with amd-pstate governor)
- GPU configuration (easyNvidia module manages NVIDIA + AMD PRIME)
- Boot setup and filesystem

### 4. **GPU Management (easyNvidia Module)**
Advanced hybrid GPU setup:
- NVIDIA GPU as primary for games/compute
- AMD iGPU as fallback for power saving
- PRIME offload for VAAPI hardware acceleration
- Power management through nvidia-powerd
- Modesetting enabled for Wayland support

### 5. **Systemd Service Automation**
Custom services in `modules/custom/`:
- **download-sorter.nix**: Python script that runs daily (5 AM) to organize Downloads folder by age
- **zen-autobackup.nix**: Restic-based encrypted backup of Zen browser profile (`/home/lux/.zen`), with retention policies (1 daily, 2 weekly, 2 monthly)

### 6. **Home-Manager Integration**
User-level configuration in `hosts/home.nix`:
- Shell setup: Zsh with Starship prompt, zoxide, carapace completion
- Development tools: VS Code, Cursor, Windsurf, Neovim, Git with delta
- Languages: Node.js 22, Python 3.12, JDK, Cargo
- Browsers: Firefox, Zen (custom overlay)
- Communication: Discord, Telegram

### 7. **Secrets Management**
- SOPS-Nix with age encryption
- Secrets stored in `hosts/secrets/secrets.yaml`
- Examples: Restic backup password, repository paths
- Accessed via `config.sops.secrets.<name>` pattern

### 8. **Declarative Disk Management (Disko)**
- Located in `hosts/disk.nix`
- Defines partitioning, formatting, and mounting in pure Nix
- **Boot Partition**: 2 GB EFI FAT32 (ample for kernel configs and generations)
- **Filesystem**: Btrfs with zstd:3 compression for all subvolumes
- **Mount Options**: `relatime`, `discard=async` for optimal performance on SSDs
- **Space Layout**: Linux partition uses all disk space except last 150 GB (reserved for Windows)
- **Subvolume Layout**:
  - `@` → `/` (root filesystem)
  - `@home` → `/home` (user data)
  - `@nix` → `/nix` (Nix store)
  - `@var` → `/var` (logs, caches)
  - `@tmp` → `/tmp` (temporary files)
- Enables reproducible, version-controlled disk layouts across installs
- Can be used during fresh installation or to repartition existing systems
- Dual-boot ready: 150 GB space pre-allocated for Windows installation

## Common Development Tasks

### Update Dependencies
```bash
just upp
```
Updates `flake.lock` to latest versions from all flake inputs.

### Test Configuration Changes
For the active laptop configuration:
```bash
just nhleptuptest
```
Builds new config without rebooting. Check output for errors before applying.

### Apply Configuration Changes

**Option A: Immediate switch (no reboot)**
```bash
just nhleptupnow
```

**Option B: Boot into new config (with reboot)**
```bash
just nhleptup
```

### Other Useful Just Commands
```bash
just home-switch          # Apply home-manager user config only
just history              # Show NixOS generation history
just gc                   # Garbage collect unused nix store
just repl                 # Interactive Nix REPL for testing expressions
just --list              # Display all available Just commands
```

### Manage Secrets
1. Edit `hosts/secrets/secrets.yaml` (will be auto-encrypted on flake eval)
2. Reference in modules: `config.sops.secrets.<name>` or `${config.sops.secrets.<name>.path}`
3. Rebuild: `just nhleptupnow`

### Format Nix Code
```bash
alejandra <file>          # Primary formatter (from nix-helpers)
nixpkgs-fmt <file>        # Alternative formatter
```

### Inspect Package Changes
```bash
nvd diff /run/current-system result  # Compare system generations
```

## Disko: Declarative Disk Partitioning

### Fresh System Installation with Disko

For a complete guide to installing NixOS using disko, see **DISKO_INSTALL.md**.

Quick reference:
```bash
# 1. Boot NixOS live USB and clone this repo
git clone https://github.com/yourusername/nixos-config
cd nixos-config

# 2. Format and partition the disk (WARNING: ERASES ENTIRE DISK)
sudo nix run github:nix-community/disko -- --mode disko ./hosts/disk.nix

# 3. Install NixOS from flake
sudo nixos-install --flake '.#leptup' --root /mnt

# 4. Reboot and finish setup
sudo reboot
```

### Disk Configuration Details

**File**: `hosts/disk.nix`

**Disk**: `/dev/nvme0n1` (NVMe SSD)

**Partitions**:
- **EFI Boot**: 2 GB FAT32 at `/boot` (ample space for kernel configs and multiple generations)
- **Root**: All remaining space minus 150 GB, formatted as Btrfs with 5 subvolumes
- **Windows Reserve**: 150 GB unpartitioned space at end for dual-boot Windows installation

**Btrfs Subvolumes** (all with zstd:3 compression):
- `@` - Root filesystem (`/`)
- `@home` - User home directories (`/home`)
- `@nix` - Nix package store (`/nix`)
- `@var` - Variable data, logs, caches (`/var`)
- `@tmp` - Temporary files (`/tmp`)

**Rationale for subvolume separation**:
- Easy snapshots of user data without system files
- Separate garbage collection policies
- Isolate I/O patterns (tmp/var from system)
- Enable per-subvolume backup strategies

### Customizing Disko Configuration

**Change disk device**:
Edit `flake.nix`:
```nix
{
  _module.args.disks = ["/dev/sda"];  # Change from nvme0n1
}
```

**Adjust compression**:
Edit `hosts/disk.nix`:
```nix
"@" = {
  mountOptions = [
    "compress=zstd:1"  # Levels 1-15, default 3 is balanced
    ...
  ];
};
```

**Add new subvolume**:
Add to `hosts/disk.nix` subvolumes section:
```nix
"@custom" = {
  mountpoint = "/custom/path";
  mountOptions = [ "compress=zstd:3" "relatime" "discard=async" ];
};
```

Then reference in system config with proper mount options.

### Btrfs Maintenance

Monitor disk health after installation:
```bash
sudo btrfs filesystem usage /              # View usage and compression ratio
sudo btrfs device stats /                  # Check for errors
sudo btrfs subvolume list /                # List all subvolumes
sudo nix-collect-garbage -d                # Clean up unused nix store
```

## Important Implementation Details

### GPU Configuration (easyNvidia)
- Located in `modules/easyNvidia/default.nix`
- Handles both NVIDIA (proprietary) and AMD (AMDGPU) setup
- Key settings:
  - `hardware.nvidia.prime.offload.enable = true`
  - NVIDIA for games/compute, AMD iGPU for battery life
  - Wayland modesetting requires NVIDIA driver rebuild
- Check GPU status: `nvidia-smi` or `radeontop`

### Audio System (PipeWire)
- Replaced PulseAudio with PipeWire + WirePlumber (modern standard)
- Located in `modules/system/pipewire.nix`
- Provides lower latency, better hardware support, and Bluetooth audio

### Power Management (TLP)
- Linux power management tool
- AMD CPU turbo boost disabled by default for battery efficiency
- Located in `modules/system/power.nix`

### Custom Download Organization
- Runs Python script daily at 5:00 AM
- Moves downloads older than 7 days into categorized folders
- Preserves metadata and runs as user `lux`
- Edit script in `modules/custom/download-sorter.nix`

### Restic Backup Integration
- Automatically backs up `~/.zen` (browser profile) on boot + scheduled intervals
- Password and repo path from secrets
- Retention: 1 daily, 2 weekly, 2 monthly snapshots
- Check backup: `restic snapshots` (with proper environment variables)

### Flake Inputs Management
Key inputs in `flake.nix`:
- `nixpkgs` (unstable)
- `nixpkgs-stable` (stable branch)
- `home-manager` (user config)
- `nixos-hardware` (hardware configs)
- `stylix` (theming system)
- `sops-nix` (secrets)
- `zen-browser` (custom browser)
- `nix-flatpak` (Flatpak app support)
- And ~15 others for specific features

## Development Environment

### Available Development Tools
All pre-configured in home-manager config (`hosts/home.nix`):
- **Shells**: Zsh + Starship prompt + direnv + nix-direnv
- **Editors**: Neovim (CLI), VS Code, Cursor, Windsurf (IDEs)
- **Languages**: Node.js 22, Bun, Python 3.12, JDK, Cargo, C/C++ (gcc, cmake)
- **Version Control**: Git with delta diff viewer
- **Utilities**: Carapace (completions), Zoxide (navigation), Git CLI

### Nix Development
- `just repl`: Start interactive Nix REPL to test expressions
- `nix-direnv` enables automatic `.envrc` loading for project shells
- `nix-index` provides command-not-found suggestions

## Special Considerations

### Bluetooth Device Issue
A custom udev rule disables the MediaTek Bluetooth adapter (A8:6E:84:20:D8:B7) due to compatibility issues. If adding Bluetooth devices, check `modules/system/bluetooth.nix` for the udev rules.

### NVIDIA Wayland
Wayland support on NVIDIA requires driver rebuilds. Changes to Wayland settings may trigger full GPU driver compilation. This is expected and can take 10-15 minutes.

### Sudo-rs
System uses `sudo-rs` (memory-safe Rust implementation) instead of traditional sudo. Behavior is identical; this is just a more secure alternative.

### Firewall Configuration
Selective ports opened in `modules/networking/default.nix`. Before exposing services, ensure ports are explicitly opened via `networking.firewall.allowedTCPPorts` or UDP equivalent.

### Home-Manager Conflicts
If you modify both `hosts/base.nix` (system) and `hosts/home.nix` (user env), rebuild both:
```bash
just home-switch    # Apply user config
just nhleptupnow    # Apply system config
```
Or run both in sequence.

## Troubleshooting Common Issues

### Build Fails with Dependency Error
Run `just upp` to update flake.lock, then retry. Some inputs may have breaking changes in unstable channel.

### Secrets Not Found
Ensure `hosts/secrets/secrets.yaml` is encrypted and exists. Run `sops hosts/secrets/secrets.yaml` to edit (requires age key at `~/.ssh/keys.txt`).

### GPU Not Working
Check `modules/easyNvidia/default.nix` settings. Run `nvidia-smi` to verify driver. For Wayland issues, check modesetting is enabled.

### Systemd Service Failed
Check journal: `journalctl -u <service-name> -n 50`. For download-sorter, check `/home/lux/Downloads` permissions. For Restic backup, verify secrets exist and repository is accessible.

### Flake Evaluation Errors
Ensure all custom overlays in `overlays/` are valid Nix. Use `just repl` to test expressions. Run `nix flake check` for validation (if available).
