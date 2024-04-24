{ config, ... }:

{
    # power-management shi
    powerManagement = {
        enable = true;
        powertop.enable = true;
        # cpuFreqGovernor = "powersave";
    };

    services = {

        power-profiles-daemon.enable = false;

        auto-cpufreq = {
            enable = true;
            settings = {
                battery = {
                    governor = "powersave";
                    turbo = "never";
                    };
                charger = {
                    governor = "powersave";
                    turbo = "auto";
                };
            };
        };

        system76-scheduler = {
            enable = true;
            useStockConfig = true;
        };

        tlp = {
        enable = true;
            settings = {
                # CPU_SCALING_GOVERNOR_ON_AC = "performance";
                # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

                # CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
                # CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

                CPU_MIN_PERF_ON_AC = 0;
                CPU_MAX_PERF_ON_AC = 100;
                CPU_MIN_PERF_ON_BAT = 0;
                CPU_MAX_PERF_ON_BAT = 20;

                STOP_CHARGE_THRESH_BAT1 = 80; # 80 and above it stops charging
            };
        };
    };
}
