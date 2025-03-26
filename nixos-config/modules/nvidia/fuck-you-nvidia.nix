{
  lib,
  pkgs,
  ...
}: {
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
        "nvidiafb"
        "nvidia_drm"
        "nvidia_modeset"
        "nvidia-uvm"
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
    # services.supergfxd.enable = lib.mkForce false;
  };
}
