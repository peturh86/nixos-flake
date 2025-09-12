#!/usr/bin/env bash
set -euo pipefail

# === Partition and Format Script ===
# Usage: ./scripts/partition.sh <disk> <boot_size> <swap_size>

DISK="${1:-/dev/sda}"
BOOT_SIZE="${2:-512MB}"
SWAP_SIZE="${3:-8GB}"

echo "[*] Creating partitions on $DISK..."
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MB "$BOOT_SIZE"
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart root ext4 "$BOOT_SIZE" -"$SWAP_SIZE"
parted "$DISK" -- mkpart swap linux-swap -"$SWAP_SIZE" 100%

echo "[*] Formatting partitions..."
mkfs.fat -F 32 -n boot "${DISK}1"
mkfs.ext4 -L nixos "${DISK}2"
mkswap -L swap "${DISK}3"

# Brief delay to ensure formatting is complete
sleep 0.3

echo "[*] Partitioning and formatting complete!"
