#!/usr/bin/env bash
set -euo pipefail

# === Partition and Format Script ===
# Usage: ./scripts/partition.sh <disk> <boot_size> <swap_size>

DISK="${1:-/dev/sda}"
BOOT_SIZE="${2:-512MB}"
SWAP_SIZE="${3:-8GB}"

# Determine partition naming convention
if [[ "$DISK" =~ nvme ]]; then
  # NVMe drives use 'p' prefix for partitions
  ESP_PART="${DISK}p1"
  ROOT_PART="${DISK}p2"
  SWAP_PART="${DISK}p3"
else
  # SATA/SCSI drives don't use 'p' prefix
  ESP_PART="${DISK}1"
  ROOT_PART="${DISK}2"
  SWAP_PART="${DISK}3"
fi

echo "[*] Creating partitions on $DISK..."
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MB "$BOOT_SIZE"
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart root ext4 "$BOOT_SIZE" -"$SWAP_SIZE"
parted "$DISK" -- mkpart swap linux-swap -"$SWAP_SIZE" 100%

echo "[*] Formatting partitions..."
mkfs.fat -F 32 -n boot "$ESP_PART"
mkfs.ext4 -L nixos "$ROOT_PART"
mkswap -L swap "$SWAP_PART"

# Brief delay to ensure formatting is complete
sleep 0.3

echo "[*] Partitioning and formatting complete!"
