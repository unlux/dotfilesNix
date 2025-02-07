{lib, ...}: {
  specialisation = {
    gaming-time.configuration = {
      hardware.nvidia = {
        prime.reverseSync.enable = lib.mkForce true;
        powerManagement.enable = lib.mkForce false;
        powerManagement.finegrained = lib.mkForce false;
        prime.offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };

      environment.variables = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
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
