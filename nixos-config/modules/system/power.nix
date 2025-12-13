_: {
  services = {
    # Disable GNOMEs power management (conflicts with TLP)
    power-profiles-daemon.enable = false;

    # Process scheduling optimization - good for desktop responsiveness
    # Doesn't conflict with TLP (TLP handles power, this handles scheduling)
    system76-scheduler = {
      enable = true;
      settings.cfsProfiles.enable = true;
    };

    tlp = {
      enable = true;
      settings = {
        # Platform profile
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "balanced"; # was: powersave (too aggressive)

        # CPU governor - schedutil is modern and responsive
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "schedutil"; # was: powersave (causes jank)

        # Energy/performance policy
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance"; # was: power (too aggressive)

        # Turbo boost - keep enabled for responsiveness
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 1; # was: 0 (disabling boost causes stutters)

        # AMD pstate driver mode
        CPU_DRIVER_OPMODE_ON_AC = "active";
        CPU_DRIVER_OPMODE_ON_BAT = "active";

        # Battery charge threshold (good for battery longevity)
        STOP_CHARGE_THRESH_BAT1 = 80;

        # USB settings
        USB_AUTOSUSPEND = 0;
        USB_BLACKLIST_WWAN = 1;
        USB_EXCLUDE_BTUSB = 1;
        USB_EXCLUDE_PHONE = 1;

        # PCIe runtime PM - keep devices awake to avoid wake-up latency
        RUNTIME_PM_ON_AC = "on"; # Devices stay on
        RUNTIME_PM_ON_BAT = "on"; # was: auto (causes wake-up stutters)
      };
    };
  };
}
