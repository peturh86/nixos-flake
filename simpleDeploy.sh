#!/usr/bin/env bash
set -euo pipefail

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

# Partition layout:
# 1. ESP (EFI System Partition) - fat32, 1MB to BOOT_SIZE
# 2. Root - ext4, BOOT_SIZE to -(SWAP_SIZE)
# 3. Swap - linux-swap, -(SWAP_SIZE) to 100%

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

echo "[*] Creating partitions..."
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MB "$BOOT_SIZE"
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart root ext4 "$BOOT_SIZE" -"$SWAP_SIZE"
parted "$DISK" -- mkpart swap linux-swap -"$SWAP_SIZE" 100%

echo "[*] Formatting partitions..."
mkfs.fat -F 32 -n boot "${DISK}1"
mkfs.ext4 -L nixos "${DISK}2"
mkswap -L swap "${DISK}3"

sleep 1

echo "[*] Mounting partitions..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap

echo "[*] Generating NixOS configuration..."
nixos-generate-config --root /mnt

echo "[*] Creating custom kiosk configuration..."
cat > /mnt/etc/nixos/kiosk-config.nix << EOF
{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./kiosk-base.nix
  ];

  networking.hostName = "$HOSTNAME";

  # Override kiosk settings
  services.kiosk = {
    user = "$KIOSK_USER";
    password = "$KIOSK_PASSWORD";
    timeZone = "$TIMEZONE";
    locale = "$LOCALE";
    kioskUrl = "$KIOSK_URL";
  };
}
EOF

# Copy the kiosk-base module
#cp modules/kiosk-base.nix /mnt/etc/nixos/

# Modify the generated configuration.nix to use our custom config
#sed -i 's|./hardware-configuration.nix|./kiosk-config.nix|' /mnt/etc/nixos/configuration.nix

echo "[*] Installing NixOS..."
# Use the generated configuration with our custom kiosk settings
nixos-install --root /mnt

echo "[*] Installation complete!"
echo "You can now reboot into your new NixOS kiosk system." 