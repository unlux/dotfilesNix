{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    dynamicBoost.enable = true;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "570.86.16"; # use new 570 drivers
      sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
      openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
      settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
      usePersistenced = false;
    };
  };

  boot = {
    # kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_xanmod;
    kernelPackages = pkgs.linuxPackages_latest;

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
  };

  environment = {
    systemPackages = (
      with pkgs; [
        # nvidia-vaapi-driver
        # # libva
        libva-utils
        # nvidia-utils
        # # libvdpau-va-gl
        # # vaapiVdpau
        # # libva-vdpau-driver
        nvtopPackages.full
        nvidia-container-toolkit
      ]
    );
    # sessionVariables = {
    #   "__EGL_VENDOR_LIBRARY_FILENAMES" = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/10_nvidia.json";
    # };

    variables = {
      NVD_BACKEND = "direct";
      LIBVA_DRIVER_NAME = "nvidia";
      MOZ_DISABLE_RDD_SANDBOX = "1";
      # Required to run the correct GBM backend for nvidia GPUs on wayland
      GBM_BACKEND = "nvidia-drm";
      # Apparently, without this nouveau may attempt to be used instead
      # (despite it being blacklisted)
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # Hardware cursors are currently broken on wlroots
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };

  # environment.variables = {
  #   # references -> https://github.com/TLATER/dotfiles/blob/e633196dca42d96f42f9aa9016fa8d307959232f/home-config/config/graphical-applications/firefox.nix#L68
  #   __NV_PRIME_RENDER_OFFLOAD = 1;
  #   __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
  #   __VK_LAYER_NV_optimus = "NVIDIA_only";
  #   # Required to run the correct GBM backend for nvidia GPUs on wayland
  #   # Apparently, without this nouveau may attempt to be used instead
  #   # (despite it being blacklisted)
  #   # GBM_BACKEND = "nvidia-drm";
  #   # Hardware cursors are currently broken on nvidia
  #   WLR_NO_HARDWARE_CURSORS = "0";
  #   # In order to automatically launch Steam in offload mode, you need to add the following to your ~/.bashrc:
  #   XDG_DATA_HOME = "$HOME/.local/share";
  #   # from https://github.com/TLATER/dotfiles/blob/e633195dca42d96f42f9aa9016fa8d307959232f/nixos-config/yui/nvidia.nix#L33
  #   # Necessary to correctly enable va-api (video codec hardware
  #   # acceleration). If this isn't set, the libvdpau backend will be
  #   # picked, and that one doesn't work with most things, including
  #   # Firefox.
  #   LIBVA_DRIVER_NAME = "nvidia";
  #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  #   # Required to use va-api it in Firefox. See
  #   # https://github.com/elFarto/nvidia-vaapi-driver/issues/95
  #   MOZ_DISABLE_RDD_SANDBOX = "0";
  #   # It appears that the normal rendering mode is broken on recent
  #   # nvidia drivers:
  #   # https://github.com/elFarto/nvidia-vaapi-driver/issues/212#issuecomment-1585584038
  #   NVD_BACKEND = "direct";
  #   # Required for firefox 97+, see:
  #   # https://github.com/elFarto/nvidia-vaapi-driver#firefox
  #   EGL_PLATFORM = "wayland";
  # };

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
    # services.supergfxd.enable = lib.mkForce false;
  };
}
