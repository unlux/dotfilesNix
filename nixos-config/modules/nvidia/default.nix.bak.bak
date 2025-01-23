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
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "535.154.05";
      sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
      sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
      openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
      settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
      persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
    };
  };

  environment.variables = {
    # references -> https://github.com/TLATER/dotfiles/blob/e633196dca42d96f42f9aa9016fa8d307959232f/home-config/config/graphical-applications/firefox.nix#L68
    __NV_PRIME_RENDER_OFFLOAD = 1;
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
    # Required to run the correct GBM backend for nvidia GPUs on wayland
    # Apparently, without this nouveau may attempt to be used instead
    # (despite it being blacklisted)
    # GBM_BACKEND = "nvidia-drm";
    # Hardware cursors are currently broken on nvidia
    WLR_NO_HARDWARE_CURSORS = "0";
    # In order to automatically launch Steam in offload mode, you need to add the following to your ~/.bashrc:
    XDG_DATA_HOME = "$HOME/.local/share";
    # from https://github.com/TLATER/dotfiles/blob/e633195dca42d96f42f9aa9016fa8d307959232f/nixos-config/yui/nvidia.nix#L33
    # Necessary to correctly enable va-api (video codec hardware
    # acceleration). If this isn't set, the libvdpau backend will be
    # picked, and that one doesn't work with most things, including
    # Firefox.
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Required to use va-api it in Firefox. See
    # https://github.com/elFarto/nvidia-vaapi-driver/issues/95
    MOZ_DISABLE_RDD_SANDBOX = "0";
    # It appears that the normal rendering mode is broken on recent
    # nvidia drivers:
    # https://github.com/elFarto/nvidia-vaapi-driver/issues/212#issuecomment-1585584038
    NVD_BACKEND = "direct";
    # Required for firefox 97+, see:
    # https://github.com/elFarto/nvidia-vaapi-driver#firefox
    EGL_PLATFORM = "wayland";
  };

  environment.systemPackages = (
    with pkgs; [
      nvidia-vaapi-driver
      # libva
      # libva-utils
      # libvdpau-va-gl
      # vaapiVdpau
      # libva-vdpau-driver
      nvtopPackages.full
    ]
  );
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
