{
  config,
  lib,
  pkgs,
  ...
}: {
  specialisation.battery.configuration = {
    system.nixos.tags = ["battery"];

    # Disable the entire easyNvidia module tree (driver, prime offload, de-compat)
    easyNvidia.enable = lib.mkForce false;
    # Explicitly disable NVIDIA VAAPI since leptup.nix sets it to true unconditionally
    easyNvidia.vaapi.enable = lib.mkForce false;

    # Blacklist all NVIDIA and nouveau kernel modules
    boot.blacklistedKernelModules = [
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
      "nouveau"
      "nvidiafb"
      "rivafb"
      "rivatv"
    ];

    # Belt-and-suspenders: modprobe blacklist + disable nouveau modesetting
    boot.extraModprobeConfig = lib.mkAfter ''
      blacklist nouveau
      options nouveau modeset=0
    '';

    # Remove all NVIDIA PCI devices on boot — physically powers off the GPU
    # Vendor 0x10de = NVIDIA. Each rule targets a different device class:
    #   0x0c0330 = USB xHCI controller, 0x0c8000 = USB Type-C UCSI,
    #   0x040300 = audio controller,     0x03xxxx = VGA/3D controller
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
    '';

    # Sunshine depends on NVENC — can't run without the NVIDIA GPU
    services.sunshine.enable = lib.mkForce false;

    # Remove 80% charge cap — need full capacity for travel
    services.tlp.settings.STOP_CHARGE_THRESH_BAT1 = lib.mkForce 100;
  };
}
