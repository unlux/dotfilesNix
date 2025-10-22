{disks ? ["/dev/nvme0n1"], ...}: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            # EFI Boot Partition (increased to 2GB for config storage)
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                label = "NIXOS_BOOT";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };

            # Main root partition with Btrfs subvolumes
            # Size: all space except last 150GB (reserved for Windows)
            root = {
              size = "-150G";
              content = {
                type = "btrfs";
                label = "nixos";
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  # Main root subvolume (@) - contains /etc, /usr, /opt, /srv, /root
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [
                      "defaults"
                      "compress=zstd:3"
                      "relatime"
                      "discard=async"
                    ];
                  };

                  # Home directory subvolume - separate for easy snapshots and backups
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "defaults"
                      "compress=zstd:3"
                      "relatime"
                      "discard=async"
                    ];
                  };

                  # Nix store - separate for CoW optimization and snapshots
                  # Note: Disko recommends separate subvol for better deduplication
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "defaults"
                      "compress=zstd:3"
                      "relatime"
                      "discard=async"
                    ];
                  };

                  # Variable data - logs, caches, databases, etc.
                  "@var" = {
                    mountpoint = "/var";
                    mountOptions = [
                      "defaults"
                      "compress=zstd:3"
                      "relatime"
                      "discard=async"
                    ];
                  };

                  # Temporary files - optimized for transient workloads
                  # noatime: skip access time updates; nodatacow: disable CoW for speed
                  "@tmp" = {
                    mountpoint = "/tmp";
                    mountOptions = [
                      "noatime"
                      "nodatacow"
                      "compress=zstd:3"
                      "discard=async"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
