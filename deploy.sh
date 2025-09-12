#!/usr/bin/env bash
set -euo pipefail

HOSTNAME="${1:-}"
MNT="/mnt"
HOSTS_DIR="$(dirname "$0")/hosts"

if [ -z "$HOSTNAME" ]; then
  echo "Usage: $0 <hostname>"
  exit 1
fi

HOST_DIR="$HOSTS_DIR/$HOSTNAME"

if [ ! -d "$HOST_DIR" ]; then
  echo "Error: host folder $HOST_DIR does not exist."
  echo "Create it and add configuration.nix before deploying."
  exit 1
fi

if [ ! -d "$MNT/etc" ]; then
  echo "Error: $MNT is not mounted. Partition & mount before running this script."
  exit 1
fi

echo "[*] Generating hardware-configuration.nix..."
nixos-generate-config --root "$MNT"

echo "[*] Copying hardware-configuration.nix into $HOST_DIR..."
mv "$MNT/etc/nixos/hardware-configuration.nix" "$HOST_DIR/"

echo "[*] Installing NixOS for $HOSTNAME..."
nixos-install --flake "$PWD#$HOSTNAME"

echo "[*] Done! Reboot into your kiosk system."
