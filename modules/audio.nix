{ config, pkgs, lib, ... }:

{
  # Advanced audio configuration to fix microphone volume issues
  
  # PipeWire configuration
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # Disable automatic gain control and other auto-adjustments
    extraConfig.pipewire."10-disable-agc" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
      };
      "context.modules" = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            "pulse.properties" = {
              # Disable all automatic adjustments
              "pulse.default.frag" = "960/48000";
              "pulse.default.tlength" = "960/48000";
              "pulse.default.prebuf" = "960/48000";
              "pulse.default.minreq" = "32/48000";
            };
          };
        }
      ];
    };

    # Configure input devices to prevent auto-adjustment
    extraConfig.pipewire-pulse."10-disable-input-auto-adjust" = {
      "pulse.properties" = {
        "pulse.min.req" = "32/48000";
        "pulse.default.req" = "960/48000";
        "pulse.max.req" = "8192/48000";
        "pulse.min.quantum" = "32/48000";
        "pulse.max.quantum" = "8192/48000";
      };
      "stream.properties" = {
        "node.latency" = "32/48000";
        "resample.quality" = 1;
        # Disable automatic gain control
        "channelmix.disable" = false;
        "channelmix.min-volume" = 0.0;
        "channelmix.max-volume" = 10.0;
      };
      "context.properties" = {
        # Disable echo cancellation and noise reduction
        "aec.enabled" = false;
        "agc.enabled" = false;
        "ns.enabled" = false;
      };
    };

    # Disable WebRTC audio processing
    extraConfig.pipewire."20-disable-webrtc" = {
      "context.modules" = [
        {
          name = "libpipewire-module-echo-cancel";
          args = {
            "aec.method" = "none";
            "agc.enabled" = false;
            "ns.enabled" = false;
          };
        }
      ];
    };
  };

  # Audio packages
  environment.systemPackages = with pkgs; [
    pavucontrol      # PulseAudio Volume Control
    pulseaudio       # PulseAudio utilities
    easyeffects      # Audio effects and processing
    helvum           # PipeWire patchbay
    qpwgraph         # PipeWire graph manager
    pwvucontrol      # PipeWire Volume Control
  ];

  # Security for real-time audio
  security.rtkit.enable = true;

  # Create custom PipeWire configuration files
  environment.etc = {
    "pipewire/pipewire.conf.d/99-disable-agc.conf".text = ''
      context.properties = {
        default.clock.rate = 48000
        default.clock.quantum = 1024
        default.clock.min-quantum = 32
        default.clock.max-quantum = 2048
      }

      context.modules = [
        {
          name = libpipewire-module-protocol-pulse
          args = {
            pulse.properties = {
              pulse.default.frag = "960/48000"
              pulse.default.tlength = "960/48000"
              pulse.default.prebuf = "960/48000"
              pulse.default.minreq = "32/48000"
            }
          }
        }
      ]
    '';

    "pipewire/pipewire-pulse.conf.d/99-disable-input-processing.conf".text = ''
      pulse.properties = {
        pulse.min.req = "32/48000"
        pulse.default.req = "960/48000"
        pulse.max.req = "8192/48000"
        pulse.min.quantum = "32/48000"
        pulse.max.quantum = "8192/48000"
      }

      stream.properties = {
        node.latency = "32/48000"
        resample.quality = 1
        channelmix.disable = false
        channelmix.min-volume = 0.0
        channelmix.max-volume = 10.0
      }

      context.properties = {
        # Completely disable all audio processing
        aec.enabled = false
        agc.enabled = false
        ns.enabled = false
        webrtc.enabled = false
      }
    '';

    "wireplumber/wireplumber.conf.d/99-disable-agc.conf".text = ''
      monitor.alsa.rules = [
        {
          matches = [
            {
              device.name = "~alsa_card.*"
            }
          ]
          actions = {
            update-props = {
              api.alsa.use-acp = true
              api.alsa.disable-batch = true
              # Disable automatic gain control
              device.profile.pro-audio = true
            }
          }
        }
      ]

      monitor.alsa.properties = {
        alsa.mixer.ignore-dB = true
      }
    '';
  };
}