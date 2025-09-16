#!/usr/bin/env bash
set -euo pipefail

# === NixOS Kiosk Deployment Script ===
# Interactive disk selection with no hardcoded defaults

# === Configuration Variables ===
DISK="${DISK:-}"
HOSTNAME="${HOSTNAME:-kiosk-001}"
SWAP_SIZE="${SWAP_SIZE:-8GB}"
BOOT_SIZE="${BOOT_SIZE:-512MB}"
KIOSK_USER="${KIOSK_USER:-kiosk}"
KIOSK_PASSWORD="${KIOSK_PASSWORD:-}"
TIMEZONE="${TIMEZONE:-UTC}"
LOCALE="${LOCALE:-en_US.UTF-8}"
KIOSK_URL="${KIOSK_URL:-https://factory-app.local}"

# === Interactive Disk Selection ===
if [ -z "$DISK" ]; then
  echo "=== Available Storage Devices ==="
  lsblk -d -o NAME,SIZE,MODEL,VENDOR
  echo
  echo "⚠️  WARNING: This will DESTROY all data on the selected disk!"
  echo
  while true; do
    read -rp "Enter target disk name (e.g., sda, nvme0n1): " DISK_NAME
    if [ -n "$DISK_NAME" ]; then
      DISK="/dev/$DISK_NAME"
      break
    fi
  done
fi

# Validate disk exists
if [ ! -b "$DISK" ]; then
  echo "❌ Error: $DISK is not a valid block device."
  exit 1
fi

echo "=== NixOS Kiosk Deployment Configuration ==="
echo "Disk: $DISK"
echo "Hostname: $HOSTNAME"
echo "Boot partition size: $BOOT_SIZE"
echo "Swap size: $SWAP_SIZE"
echo "Kiosk User: $KIOSK_USER"
echo "Timezone: $TIMEZONE"
echo "Locale: $LOCALE"
echo "Kiosk URL: $KIOSK_URL"
echo

# Confirm before proceeding
read -rp "⚠️  This will DESTROY all data on $DISK. Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Aborted by user."
    exit 1
fi

# === Execute Deployment Steps ===

echo "🔧 Step 1: Partitioning and formatting disk..."
./scripts/partition.sh "$DISK" "$BOOT_SIZE" "$SWAP_SIZE"

echo "🔧 Step 2: Mounting partitions..."
./scripts/mount.sh "$DISK"

echo "🔧 Step 3: Configuring NixOS..."
./scripts/configure.sh "$HOSTNAME" "$KIOSK_USER" "$KIOSK_PASSWORD" "$TIMEZONE" "$LOCALE" "$KIOSK_URL"

echo "🔧 Step 3.5: Copying hardware configuration to repo..."
mkdir -p "hosts/$HOSTNAME"
cp "/mnt/etc/nixos/hardware-configuration.nix" "hosts/$HOSTNAME/"

echo "🔧 Step 4: Installing NixOS..."
./scripts/install.sh

echo "✅ All steps completed successfully!"
echo "🎉 You can now reboot into your NixOS kiosk system!" 