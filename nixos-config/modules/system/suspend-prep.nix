{pkgs, ...}: {
  # Suspend preparation and wake-up optimization
  systemd.services.prepare-suspend = {
    description = "Prepare system for suspend";
    before = ["sleep.target"];
    wantedBy = ["sleep.target"];
    unitConfig.StopWhenUnneeded = true;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'sync && sleep 0.5'";
      RemainAfterExit = true;
    };
  };

  # Improve wake-up performance by restoring devices faster
  systemd.services.resume-devices = {
    description = "Resume system after wake-up";
    after = ["sleep.target"];
    wantedBy = ["sleep.target"];
    unitConfig.StopWhenUnneeded = true;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'for i in /sys/bus/pci/devices/*/power/control; do echo on > $i 2>/dev/null; done'";
      RemainAfterExit = true;
    };
  };

  # Disable unnecessary services before sleep
  systemd.services.pre-sleep-cleanup = {
    description = "Cleanup before sleep";
    before = ["sleep.target"];
    wantedBy = ["sleep.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'systemctl stop gpg-agent.socket 2>/dev/null || true'";
    };
  };
}
