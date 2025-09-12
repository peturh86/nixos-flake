#!/usr/bin/env bash
set -euo pipefail

# === NixOS Kiosk Deployment Orchestrator ===
# This script coordinates the deployment process using modular scripts

# === Configuration Variables ===
DISK="${DISK:-/dev/sda}"
HOSTNAME="${HOSTNAME:-kiosk-001}"
SWAP_SIZE="${SWAP_SIZE:-8GB}"
BOOT_SIZE="${BOOT_SIZE:-512MB}"
KIOSK_USER="${KIOSK_USER:-kiosk}"
KIOSK_PASSWORD="${KIOSK_PASSWORD:-}"
TIMEZONE="${TIMEZONE:-UTC}"
LOCALE="${LOCALE:-en_US.UTF-8}"
KIOSK_URL="${KIOSK_URL:-https://factory-app.local}"

echo "=== NixOS Kiosk Deployment ==="
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
read -rp "Continue with these settings? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# === Execute Deployment Steps ===

echo "[*] Step 1: Partitioning and formatting disk..."
./scripts/partition.sh "$DISK" "$BOOT_SIZE" "$SWAP_SIZE"

echo "[*] Step 2: Mounting partitions..."
./scripts/mount.sh "$DISK"

echo "[*] Step 3: Configuring NixOS..."
./scripts/configure.sh "$HOSTNAME" "$KIOSK_USER" "$KIOSK_PASSWORD" "$TIMEZONE" "$LOCALE" "$KIOSK_URL"

echo "[*] Step 4: Installing NixOS..."
./scripts/install.sh

echo "[*] All steps completed successfully!" 