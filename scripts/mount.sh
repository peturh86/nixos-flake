#!/usr/bin/env bash
set -euo pipefail

# === Mount Partitions Script ===
# Usage: ./scripts/mount.sh <disk>

DISK="${1:-/dev/sda}"

echo "[*] Mounting partitions..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap

echo "[*] Partitions mounted successfully!"
