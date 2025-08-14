_: {
  # powerManagement.powertop.enable = true;

  services = {
    # Disable GNOMEs power management
    power-profiles-daemon.enable = false;

    system76-scheduler = {
      enable = true;
      settings.cfsProfiles.enable = true;
      #   useStockConfig = true;
    };

    tlp = {
      enable = true;
      settings = {
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "powersave";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_DRIVER_OPMODE_ON_AC = "active";
        CPU_DRIVER_OPMODE_ON_BAT = "active";

        STOP_CHARGE_THRESH_BAT1 = 80;
        USB_AUTOSUSPEND = 0;
        USB_BLACKLIST_WWAN = 1;
        # USB_ALLOWLIST = "46d:c07e"; # Logitech mouse
        USB_EXCLUDE_BTUSB = 1;
        USB_EXCLUDE_PHONE = 1;
        # RUNTIME_PM_BLACKLIST = "46d:c07e";
        # PCIE_ASPM_ON_BAT = "default";
        # RUNTIME_PM_ON_BAT = "on";
      };

      # extraConfig = ''
      #   USB_AUTOSUSPEND=0
      # '';
      # upower.enable = true;
    };
  };
  programs.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}
