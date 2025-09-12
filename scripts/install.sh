#!/usr/bin/env bash
set -euo pipefail

# === Install NixOS Script ===
# Usage: ./scripts/install.sh

echo "[*] Installing NixOS..."
# Use the generated configuration with our custom kiosk settings
nixos-install --root /mnt

echo "[*] Installation complete!"
echo "You can now reboot into your new NixOS kiosk system."
