# GPU Passthrough (imma kms)
let
  # RTX 3050 Mobile
  gpuIDs = [
    "10de:25a2" # Graphics
    "10de:2291" # Audio
  ];
in
  {
    lib,
    config,
    ...
  }: {
    options.vfio.enable = with lib; mkEnableOption "Configure the machine for VFIO";

    config = let
      cfg = config.vfio;
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

        kernelModules = ["kvm-amd"];

        kernelParams = [
          # enable IOMMU
          "amd_iommu=on"
          "vfio-pci.ids=10de:25a2,10de:2291"
        ];

        extraModprobeConfig = "options kvm_intel nested=1";
      };

      hardware.graphics.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;

      specialisation."VFIO".configuration = {
        system.nixos.tags = ["with-vfio"];
        vfio.enable = true;
        hardware.graphics.enable = true;
        #hardware.graphics.enable32bit = true; #disabling temproratily

        # Load nvidia driver for Xorg and Wayland
        services.xserver.videoDrivers = ["nvidia"];

        hardware.nvidia = {
          modesetting.enable = true;
          # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
          # Enable this if you have graphical corruption issues or application crashes after waking
          # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
          # of just the bare essentials.
          powerManagement.enable = lib.mkForce false;
          # Fine-grained power management. Turns off GPU when not in use.
          # Experimental and only works on modern Nvidia GPUs (Turing or newer).
          powerManagement.finegrained = lib.mkForce false;
          # - Fine-grained power management requires offload to be enabled.
          # Use the NVidia open source kernel module (not to be confused with the
          # independent third-party "nouveau" open source driver).
          # Support is limited to the Turing and later architectures. Full list of
          # supported GPUs is at:
          # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
          # Only available from driver 515.43.04+
          # Currently alpha-quality/buggy, so false is currently the recommended setting.
          open = lib.mkForce false;

          prime = {
            offload.enable = lib.mkForce true;
            offload.enableOffloadCmd = lib.mkForce true;
            sync.enable = lib.mkForce false;
            amdgpuBusId = "PCI:5:0:0";
            nvidiaBusId = "PCI:1:0:0";
          };

          # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
          nvidiaSettings = true;

          # Optionally, you may need to select the appropriate driver version for your specific GPU.
          package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
            version = "570.86.16"; # use new 570 drivers
            sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
            openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
            settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
            usePersistenced = false;
          };
        };
      };
    };
  }
