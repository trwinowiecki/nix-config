#!/usr/bin/env bash
# Reset MediaTek USB Bluetooth when hci0 exists but bluez has no controller.
set -euo pipefail

if ! lsusb -d 13d3:3567 >/dev/null 2>&1; then
    echo "No 13d3:3567 Bluetooth adapter found."
    exit 1
fi

echo "Reloading btusb..."
sudo modprobe -r btusb || true
sleep 2
sudo modprobe btusb
sleep 2

if bluetoothctl list | grep -q "^Controller"; then
    echo "Bluetooth controller is up:"
    bluetoothctl list
    bluetoothctl show | sed -n '1,6p'
else
    echo "Still no controller. Try a full reboot after nixos-rebuild."
    hciconfig -a hci0 2>/dev/null || true
    exit 1
fi
