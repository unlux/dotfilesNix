_: {
  # ZRAM is much faster than swap files and better for SSDs
  # It compresses RAM contents instead of writing to disk
  zramSwap = {
    enable = true;
    algorithm = "zstd"; # Fast compression algorithm
    memoryPercent = 50; # Use 50% of RAM for compressed swap
    priority = 10; # Higher priority than disk swap
  };

  # Keep a smaller swap file as backup
  # This will only be used if ZRAM fills up (rare)
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # Reduced from 16GB to 16GB
      priority = 5; # Lower priority than ZRAM
    }
  ];
}
