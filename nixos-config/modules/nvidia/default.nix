{ config, lib, pkgs, ...  }: 
{
  boot.kernelParams = [ "nvidia-drm.fbdev=1"];

  hardware.graphics.enable = true;
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;
    # - Fine-grained power management requires offload to be enabled.
    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 514.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      # sync.enable = lib.mkForce false;
      amdgpuBusId = "PCI:1:0:0";
      nvidiaBusId = "PCI:5:0:0";
    };
    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
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

  boot.kernelPackages = pkgs.linuxPackages_6_9;
  
  environment.variables = {
    # references -> https://github.com/TLATER/dotfiles/blob/e633196dca42d96f42f9aa9016fa8d307959232f/home-config/config/graphical-applications/firefox.nix#L68
    __NV_PRIME_RENDER_OFFLOAD=1;
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER="NVIDIA-G0";
    __VK_LAYER_NV_optimus="NVIDIA_only";
    # Required to run the correct GBM backend for nvidia GPUs on wayland
    # Apparently, without this nouveau may attempt to be used instead
    # (despite it being blacklisted)
    # GBM_BACKEND = "nvidia-drm";
    # Hardware cursors are currently broken on nvidia
    WLR_NO_HARDWARE_CURSORS = "0";
    # In order to automatically launch Steam in offload mode, you need to add the following to your ~/.bashrc: 
    XDG_DATA_HOME="$HOME/.local/share";
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

  environment.systemPackages = [ pkgs.nvidia-vaapi-driver ];
  services.supergfxd.enable = true;

  # code to turn off dGPU completely
  specialisation.fuck-you-nvidia.configuration = {
      system.nixos.tags = ["fuck-you-nvidia"];
      boot.extraModprobeConfig = lib.mkForce ''
        blacklist nouveau
        options nouveau modeset=-1
      '';
      boot.blacklistedKernelModules = lib.mkForce ["nouveau" "nvidia" "nvidia_drm" "nvidia_modeset"];
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
        services.supergfxd.enable = lib.mkForce false;
  };
}
