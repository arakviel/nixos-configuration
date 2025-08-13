#!/usr/bin/env bash

# Script to fix microphone auto-adjustment issues
# Run this script after system boot or when microphone issues occur

set -e

echo "🎤 Fixing microphone auto-adjustment issues..."

# Restart PipeWire services
echo "🔄 Restarting PipeWire services..."
systemctl --user restart pipewire pipewire-pulse wireplumber

# Wait for services to start
sleep 3

# Set microphone volume to 100% and lock it
echo "🔊 Setting microphone volume to 100%..."

# Find all input sources and set volume to 100%
pactl list short sources | grep -v monitor | while read -r line; do
    source_name=$(echo "$line" | cut -f2)
    echo "Setting volume for source: $source_name"
    pactl set-source-volume "$source_name" 100%
done

# Disable automatic gain control via PulseAudio
echo "🚫 Disabling automatic gain control..."
pactl load-module module-echo-cancel aec_method=null agc_enable=false noise_suppression=false 2>/dev/null || true

# Set ALSA mixer controls to disable AGC
echo "🎛️  Configuring ALSA mixer..."
amixer -c 0 sset 'Auto Gain Control' off 2>/dev/null || true
amixer -c 0 sset 'AGC' off 2>/dev/null || true
amixer -c 0 sset 'Mic Boost' 0 2>/dev/null || true

# Show current microphone status
echo ""
echo "📊 Current microphone status:"
pactl list short sources | grep -v monitor | while read -r line; do
    source_name=$(echo "$line" | cut -f2)
    volume=$(pactl get-source-volume "$source_name" | grep -o '[0-9]*%' | head -1)
    echo "  $source_name: $volume"
done

echo ""
echo "✅ Microphone configuration completed!"
echo ""
echo "💡 Tips:"
echo "   1. Use 'pavucontrol' to manually adjust and lock microphone volume"
echo "   2. In pavucontrol, go to 'Input Devices' tab and click the lock icon"
echo "   3. If issues persist, run this script again"
echo "   4. For permanent fix, the volume should stay at 100% after reboot"
