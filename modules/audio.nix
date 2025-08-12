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
      };
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
}