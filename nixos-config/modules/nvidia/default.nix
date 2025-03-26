{
  config,
  lib,
  pkgs,
  ...
}: {
  boot = {
    extraModprobeConfig = lib.mkDefault ''
      blacklist nouveau
      options nouveau modeset=0
    '';
    blacklistedKernelModules = lib.mkDefault [
      "nouveau"
      "nvidia"
      "nvidiafb"
      "nvidia_drm"
      "nvidia-uvm"
      "nvidia_modeset"
      "nv"
      "rivafb"
      "rivatv"
      "ipmi_msghandler"
      "ipmi_devintf"
    ];
  };

  services.udev.extraRules = lib.mkDefault ''
    # Remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA USB Type-C UCSI devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA Audio devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA VGA/2D controller devices
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  '';

  services.xserver.videoDrivers = lib.mkForce ["amdgpu"];
  services.xserver.deviceSection = ''
    Option "Modesetting" "true"
  '';

  hardware.nvidia-container-toolkit.enable = lib.mkForce false;

  # Add this to ensure no GPU drivers are loaded in default config
  # services.xserver.videoDrivers = lib.mkDefault ["modesetting"];

  # Uncomment if you want AMD to be your only GPU in default mode
  # services.xserver.videoDrivers = lib.mkDefault ["amdgpu"];

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
}
