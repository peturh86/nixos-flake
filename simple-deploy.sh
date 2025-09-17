#!/usr/bin/env bash
set -euo pipefail

# === NixOS Kiosk Deployment Script ===
# Interactive disk selection with no hardcoded defaults

chmod +x ./scripts/*.sh

# === Configuration Variables ===
DISK="${DISK:-}"
HOSTNAME="${HOSTNAME:-}"
SWAP_SIZE="${SWAP_SIZE:-8GB}"
BOOT_SIZE="${BOOT_SIZE:-512MB}"
KIOSK_USER="${KIOSK_USER:-}"
KIOSK_PASSWORD="${KIOSK_PASSWORD:-}"
TIMEZONE="${TIMEZONE:-UTC}"
LOCALE="${LOCALE:-en_US.UTF-8}"
KIOSK_URL="${KIOSK_URL:-https://factory-app.local}"
WIFI_ENABLE="${WIFI_ENABLE:-}"
WIFI_SSID="${WIFI_SSID:-}"
WIFI_PASSWORD="${WIFI_PASSWORD:-}"
WIFI_HIDDEN="${WIFI_HIDDEN:-false}"

# === Interactive Configuration ===
echo "=== NixOS Kiosk Configuration ==="

# Hostname
if [ -z "$HOSTNAME" ]; then
  read -rp "Enter hostname [kiosk-001]: " HOSTNAME
  HOSTNAME="${HOSTNAME:-kiosk-001}"
fi

# Kiosk User
if [ -z "$KIOSK_USER" ]; then
  read -rp "Enter kiosk username [kiosk]: " KIOSK_USER
  KIOSK_USER="${KIOSK_USER:-kiosk}"
fi

# Kiosk Password
if [ -z "$KIOSK_PASSWORD" ]; then
  read -rsp "Enter kiosk user password: " KIOSK_PASSWORD
  echo
  if [ -z "$KIOSK_PASSWORD" ]; then
    echo "Password cannot be empty"
    exit 1
  fi
fi

# Timezone
if [ "$TIMEZONE" = "UTC" ]; then
  read -rp "Enter timezone [UTC]: " TIMEZONE_INPUT
  TIMEZONE="${TIMEZONE_INPUT:-UTC}"
fi

# Kiosk URL
if [ "$KIOSK_URL" = "https://factory-app.local" ]; then
  read -rp "Enter kiosk URL [https://factory-app.local]: " KIOSK_URL_INPUT
  KIOSK_URL="${KIOSK_URL_INPUT:-https://factory-app.local}"
fi

# WiFi Configuration
if [ -z "$WIFI_ENABLE" ]; then
  read -rp "Enable WiFi? (y/n) [n]: " WIFI_CHOICE
  case "${WIFI_CHOICE:-n}" in
    [Yy]|[Yy][Ee][Ss])
      WIFI_ENABLE="true"
      read -rp "Enter WiFi SSID: " WIFI_SSID
      if [ -z "$WIFI_SSID" ]; then
        echo "WiFi SSID cannot be empty"
        exit 1
      fi
      read -rsp "Enter WiFi password (leave empty for open network): " WIFI_PASSWORD
      echo
      read -rp "Is WiFi network hidden? (y/n) [n]: " HIDDEN_CHOICE
      case "${HIDDEN_CHOICE:-n}" in
        [Yy]|[Yy][Ee][Ss])
          WIFI_HIDDEN="true"
          ;;
        *)
          WIFI_HIDDEN="false"
          ;;
      esac
      ;;
    *)
      WIFI_ENABLE="false"
      ;;
  esac
fi

# === Interactive Disk Selection ===
if [ -z "$DISK" ]; then
  echo "=== Available Storage Devices ==="
  lsblk -d -o NAME,SIZE,MODEL,VENDOR
  echo
  echo "WARNING: This will DESTROY all data on the selected disk!"
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
  echo "Error: $DISK is not a valid block device."
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
if [ "$WIFI_ENABLE" = "true" ]; then
  echo "WiFi: Enabled"
  echo "WiFi SSID: $WIFI_SSID"
  echo "WiFi Hidden: $WIFI_HIDDEN"
else
  echo "WiFi: Disabled"
fi
echo

read -rp "Continue with these settings? (y/n): " CONFIRM
case "${CONFIRM:-y}" in
  [Nn]|[Nn][Oo])
    echo "Deployment cancelled."
    exit 0
    ;;
  *)
    echo "Starting deployment..."
    ;;
esac

# === Execute Deployment Steps ===

echo "Step 1: Partitioning and formatting disk..."
./scripts/partition.sh "$DISK" "$BOOT_SIZE" "$SWAP_SIZE"

echo "Step 2: Mounting partitions..."
./scripts/mount.sh "$DISK"

echo "Step 3: Configuring NixOS..."
./scripts/configure.sh "$HOSTNAME" "$KIOSK_USER" "$KIOSK_PASSWORD" "$TIMEZONE" "$LOCALE" "$KIOSK_URL" "$WIFI_ENABLE" "$WIFI_SSID" "$WIFI_PASSWORD" "$WIFI_HIDDEN"

echo "Step 3.5: Copying hardware configuration to repo..."
mkdir -p "hosts/$HOSTNAME"
cp "/mnt/etc/nixos/hardware-configuration.nix" "hosts/$HOSTNAME/"

echo "Step 4: Installing NixOS..."
./scripts/install.sh

echo "All steps completed successfully!"
echo "You can now reboot into your NixOS kiosk system!" 