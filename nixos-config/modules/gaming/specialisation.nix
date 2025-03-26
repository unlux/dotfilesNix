{
  lib,
  pkgs,
  config,
  ...
}: {
  specialisation = {
    gaming-time.configuration = {
      hardware.nvidia-container-toolkit.enable = lib.mkForce true;
      services.xserver.videoDrivers = lib.mkForce ["nvidia"];

      hardware.graphics = lib.mkForce {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          # https://discourse.nixos.org/t/nvidia-open-breaks-hardware-acceleration/58770/2
          nvidia-vaapi-driver
          vaapiVdpau
          libvdpau
          libvdpau-va-gl
          vdpauinfo
          libva
          libva-utils
          # https://wiki.nixos.org/wiki/Intel_Graphics
          #vpl-gpu-rt
        ];
      };

      hardware.nvidia = lib.mkForce {
        # This will no longer be necessary when
        # https://github.com/NixOS/nixpkgs/pull/326369 hits stable
        #modesetting.enable = true;
        modesetting.enable = lib.mkForce true;
        dynamicBoost.enable = true;
        prime = {
          amdgpuBusId = "PCI:5:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };
        nvidiaSettings = true;
        # package = config.boot.kernelPackages.nvidiaPackages.beta;
        open = lib.mkForce true; #https://wiki.nixos.org/wiki/NVIDIA#cite_note-1
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "570.86.16"; # use new 570 drivers
          sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
          openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
          settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
          usePersistenced = false;
        };

        prime.reverseSync.enable = lib.mkForce true;
        powerManagement.enable = lib.mkForce false;
        powerManagement.finegrained = lib.mkForce false;
        prime.offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };

      boot = lib.mkForce {
        # kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_xanmod;
        # kernelPackages = pkgs.linuxPackages_6_6; # use 6.6 LTS kernel

        kernelParams = lib.mkMerge [
          ["nvidia-drm.fbdev=1"]
          [
            "nvidia.NVreg_UsePageAttributeTable=1" # why this isn't default is beyond me.
            "nvidia_modeset.disable_vrr_memclk_switch=1" # stop really high memclk when vrr is in use.
          ]
          (lib.mkIf config.hardware.nvidia.powerManagement.enable [
            "nvidia.NVreg_TemporaryFilePath=/var/tmp" # store on disk, not /tmp which is on RAM
          ])
        ];

        blacklistedKernelModules = ["nouveau"];
        kernelModules = ["nvidia-uvm"];
      };

      environment = lib.mkForce {
        systemPackages = (
          with pkgs; [
            # nvidia-vaapi-driver
            # # libva
            # libva-utils
            # nvidia-utils
            # # libvdpau-va-gl
            # # vaapiVdpau
            # # libva-vdpau-driver
            nvtopPackages.full
            # nvidia-container-toolkit
          ]
        );
        # sessionVariables = {
        #   "__EGL_VENDOR_LIBRARY_FILENAMES" = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/10_nvidia.json";
        # };

        variables = {
          # WLR_DRM_DEVICES = "/dev/dri/card2:/dev/dri/card1";
          # __NV_PRIME_RENDER_OFFLOAD = "1";
          # __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
          # __VK_LAYER_NV_optimus = "NVIDIA_only";

          # https://discourse.nixos.org/t/nvidia-open-breaks-hardware-acceleration/58770/12?u=randomizedcoder
          # https://gist.github.com/chrisheib/162c8cad466638f568f0fb7e5a6f4f6b#file-config-nix-L193
          MOZ_DISABLE_RDD_SANDBOX = "1";
          LIBVA_DRIVER_NAME = "nvidia";
          GBM_BACKEND = "nvidia-drm";
          NVD_BACKEND = "direct";
          EGL_PLATFORM = "wayland";
          # prevents cursor disappear when using Nvidia drivers
          WLR_NO_HARDWARE_CURSORS = "1";

          MOZ_ENABLE_WAYLAND = "1";
          XDG_SESSION_TYPE = "wayland";
          NIXOS_OZONE_WL = "1";
          __NV_PRIME_RENDER_OFFLOAD = "1";
          __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          __VK_LAYER_NV_optimus = "NVIDIA_only";
        };
      };

      # services.pipewire.extraConfig.pipewire."92-low-latency" = {
      #   "context.properties" = {
      #     "default.clock.rate" = 48000;
      #     "default.clock.quantum" = 32;
      #     "default.clock.min-quantum" = 32;
      #     "default.clock.max-quantum" = 32;
      #   };
      # };
    };
  };
}
