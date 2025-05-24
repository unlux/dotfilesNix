#!/run/current-system/sw/bin/bash

set -e

echo "🔧 Stopping Bluetooth services..."
sudo systemctl stop bluetooth
sudo systemctl stop systemd-resolved || true
sudo systemctl stop pipewire.socket pipewire.service || true
sudo systemctl stop pipewire-pulse.socket pipewire-pulse.service || true

echo "🛑 Killing leftover Bluetooth processes..."
sudo pkill -f bluetoothd || true
sudo pkill -f blueman || true
sudo pkill -f pipewire || true

echo "📦 Unloading Bluetooth kernel modules (force)..."
for module in btusb btrtl btintel btbcm bluetooth; do
  if lsmod | grep -q "$module"; then
    echo " - Removing $module"
    sudo modprobe -r "$module" || echo "   ❌ Failed to remove $module (may still be in use)"
  fi
done

sleep 1

echo "📥 Reloading kernel modules..."
sudo modprobe bluetooth
sudo modprobe btusb

sleep 1

echo "🚀 Starting Bluetooth service..."
sudo systemctl start bluetooth

echo "✅ Bluetooth stack forcefully reset. Use 'bluetoothctl' to verify."
