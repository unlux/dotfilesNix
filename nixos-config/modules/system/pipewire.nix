{pkgs, ...}: let
  pw_rnnoise_config = {
    "context.modules" = [
      {
        "name" = "libpipewire-module-filter-chain";
        "args" = {
          "node.description" = "Noise Canceling source";
          "media.name" = "Noise Canceling source";
          "filter.graph" = {
            "nodes" = [
              {
                "type" = "ladspa";
                "name" = "rnnoise";
                "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                "label" = "noise_suppressor_stereo";
                "control" = {
                  "VAD Threshold (%)" = 50.0;
                };
              }
            ];
          };
          "audio.position" = [
            "FL"
            "FR"
          ];
          "capture.props" = {
            "node.name" = "effect_input.rnnoise";
            "node.passive" = true;
          };
          "playback.props" = {
            "node.name" = "effect_output.rnnoise";
            "media.class" = "Audio/Source";
          };
        };
      }
    ];
  };
in {
  # sound.enable = true;
  security.rtkit.enable = true;
  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # wireplumber.configPackages = [
      #   (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
      #         monitor.bluez.properties = {
      #             bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
      #             bluez5.codecs = [ sbc sbc_xq aac
      #                                 "ldac" "aptx" "aptx_ll_duplex"
      #                                 "aptx_ll" "aptx_hd" "opus_05_pro"
      #                                 "opus_05_71" "opus_05_51" "opus_05"
      #                                 "opus_05_duplex" "aac" "sbc_xq" ]
      #             bluez5.enable-sbc-xq = true
      #             bluez5.enable-msbc = true
      #             bluez5.enable-hw-volume = true
      #             bluez5.hfphsp-backend = "none"
      #     } '')
      # ];
      # Disable the HFP bluetooth profile, because I always use external
      # microphones anyway. It sucks and sometimes devices end up caught
      # in it even if I have another microphone.
      # wireplumber.extraConfig = {
      #   "50-bluez" = {
      #     "monitor.bluez.rules" = [
      #       {
      #         matches = [{"device.name" = "~bluez_card.*";}];
      #         actions = {
      #           update-props = {
      #             "bluez5.auto-connect" = [
      #               "a2dp_sink"
      #               "a2dp_source"
      #             ];
      #             "bluez5.hw-volume" = [
      #               "a2dp_sink"
      #               "a2dp_source"
      #             ];
      #           };
      #         };
      #       }
      #     ];
      #     "monitor.bluez.properties" = {
      #       "bluez5.roles" = [
      #         "a2dp_sink"
      #         "a2dp_source"
      #         "bap_sink"
      #         "bap_source"
      #       ];

      #       "bluez5.codecs" = [
      #         "ldac"
      #         "aptx"
      #         "aptx_ll_duplex"
      #         "aptx_ll"
      #         "aptx_hd"
      #         "opus_05_pro"
      #         "opus_05_71"
      #         "opus_05_51"
      #         "opus_05"
      #         "opus_05_duplex"
      #         "aac"
      #         "sbc_xq"
      #         "sbc"
      #       ];

      #       "bluez5.hfphsp-backend" = "none";
      #     };
      #   };
      # };
      #        https://wiki.nixos.org/wiki/PipeWire
      # wireplumber.extraConfig."10-bluez" = {
      #   "monitor.bluez.properties" = {
      #     "bluez5.enable-sbc-xq" = true;
      #     "bluez5.enable-msbc" = true;
      #     "bluez5.enable-hw-volume" = true;
      #     "bluez5.roles" = [
      #       "hsp_hs"
      #       "hsp_ag"
      #       "hfp_hf"
      #       "hfp_ag"
      #     ];
      #   };
      # };
      extraConfig.pipewire."99-input-denoising" = pw_rnnoise_config;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
      # };
      # package = pkgs.pulseaudioFull;
    };
  };

  # programs.noisetorch.enable = true;
  environment.systemPackages = with pkgs; [pavucontrol];
}
