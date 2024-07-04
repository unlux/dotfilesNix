{ config, ... }:

{
  powerManagement = {
      enable = true;
      powertop.enable = true;
      # cpuFreqGovernor = "powersave";
  };

  services = {
      
      power-profiles-daemon.enable = false;
      upower.enable = true;

      auto-cpufreq = {
          enable = true;
          settings = {
              battery = { governor = "powersave"; turbo = "never"; };
              charger = { governor = "performance"; turbo = "auto"; };
          };
      };

      # system76-scheduler = {
      #     enable = true;
      #     useStockConfig = true;
      # };

      tlp = {
      enable = true;
          settings = {
              PLATFORM_PROFILE_ON_AC="performance";
              PLATFORM_PROFILE_ON_BAT="balanced";
              CPU_SCALING_GOVERNOR_ON_AC = "performance";
              CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
              CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
              CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
              CPU_BOOST_ON_AC=1;
              CPU_BOOST_ON_BAT=0;
              CPU_MAX_PERF_ON_AC = 100;
              CPU_MIN_PERF_ON_AC = 0;
              CPU_MAX_PERF_ON_BAT = 30;
              CPU_MIN_PERF_ON_BAT = 0;
              CPU_DRIVER_OPMODE_ON_AC="active";
              CPU_DRIVER_OPMODE_ON_BAT="active";
              STOP_CHARGE_THRESH_BAT1 = 80; 
              USB_AUTOSUSPEND=0;
              USB_BLACKLIST_WWAN=1;
              WIFI_PWR_ON_AC="off";
              WIFI_PWR_ON_BAT="off";
              RESTORE_DEVICE_STATE_ON_STARTUP=0;
              USB_ALLOWLIST="46d:c07e"; #Logitech mouse
              USB_EXCLUDE_BTUSB=1;
              USB_EXCLUDE_PHONE=1;

          };
      };
  };
}
