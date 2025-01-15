{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.kernelParams = ["nvidia-drm.fbdev=1"];

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      # sync.enable = lib.mkForce false;
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # code to turn off dGPU completely
  specialisation.fuck-you-nvidia.configuration = {
    system.nixos.tags = ["fuck-you-nvidia"];
    boot = {
      extraModprobeConfig = lib.mkForce ''
        blacklist nouveau
        options nouveau modeset=0
      '';
      blacklistedKernelModules = lib.mkForce [
        "nouveau"
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
        "nvidia-uvm"
        "nvidiafb"
        "nv"
        "rivafb"
        "rivatv"
        "ipmi_msghandler"
        "ipmi_devintf"
      ];
    };

    services.udev.extraRules = lib.mkForce ''
      # Remove NVIDIA USB xHCI Host Controller devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10dd", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA USB Type-C UCSI devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10dd", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA Audio devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10dd", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA VGA/2D controller devices
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10dd", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
    '';
  };
}
