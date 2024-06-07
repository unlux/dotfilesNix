# GPU Passthrough (imma kms)
  let
  # RTX 3050 Mobile
  gpuIDs = [
    "10de:25a2" # Graphics
    "10de:2291" # Audio
  ];
in { pkgs, lib, config, ... }: {
  options.vfio.enable = with lib;
    mkEnableOption "Configure the machine for VFIO";

  config = let cfg = config.vfio;
  in {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        # "vfio_virqfd" as of kernel 6.2 -> folded into base vfio

        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

      # loader = {
      #   systemd-boot.enable = true;
      #   efi.canTouchEfiVariables = true;
      # };

      kernelModules = [
        "kvm-amd"
      ];

      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
      ] ++ lib.optional cfg.enable
        # isolate the GPU
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);

      extraModprobeConfig = "options kvm_intel nested=1";
    };

    hardware.opengl.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    specialisation."VFIO".configuration = {
      system.nixos.tags = [ "with-vfio" ];
      vfio.enable = true;
    };

  };
}