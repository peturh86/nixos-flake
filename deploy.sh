#!/usr/bin/env bash
set -euo pipefail

# === Config ===
MNT="/mnt"
REPO="/root/nixos-config"
HOSTS_DIR="$REPO/hosts"

# === Args ===
HOSTNAME="${1:-}"
if [ -z "$HOSTNAME" ]; then
  echo "Usage: $0 <hostname>"
  exit 1
fi

HOST_DIR="$HOSTS_DIR/$HOSTNAME"
if [ ! -d "$HOST_DIR" ]; then
  echo "Error: host folder $HOST_DIR does not exist in the repo."
  exit 1
fi

# === Step 1: Select target disk ===
echo "[*] Available disks:"
lsblk -d -o NAME,SIZE,MODEL

echo
read -rp "Enter target disk (e.g. sda or nvme0n1): " DISK
DISK="/dev/$DISK"

if [ ! -b "$DISK" ]; then
  echo "Error: $DISK is not a valid block device."
  exit 1
fi

# === Step 2: Partition disk (UEFI only) ===
echo "[*] Partitioning $DISK..."
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 513MiB
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart primary ext4 513MiB 100%

EFI_PART="${DISK}p1"
ROOT_PART="${DISK}p2"
# For SATA disks like /dev/sda, partitions are sda1/sda2 (no 'p')
if [[ "$DISK" =~ /dev/sd. ]]; then
  EFI_PART="${DISK}1"
  ROOT_PART="${DISK}2"
fi

# === Step 3: Format ===
echo "[*] Formatting partitions..."
mkfs.fat -F 32 "$EFI_PART"
mkfs.ext4 -L nixos "$ROOT_PART"

# === Step 4: Mount ===
echo "[*] Mounting partitions..."
mount "$ROOT_PART" "$MNT"
mkdir -p "$MNT/boot"
mount "$EFI_PART" "$MNT/boot"

# === Step 5: Generate hardware config ===
echo "[*] Generating hardware-configuration.nix..."
nixos-generate-config --root "$MNT"

echo "[*] Copying hardware-configuration.nix into repo..."
cp "$MNT/etc/nixos/hardware-configuration.nix" "$HOST_DIR/"

# === Step 6: Install system ===
echo "[*] Installing NixOS for $HOSTNAME..."
nixos-install --flake "$REPO#$HOSTNAME" --root "$MNT"

echo "[*] Done! You can now reboot into kiosk: $HOSTNAME"
