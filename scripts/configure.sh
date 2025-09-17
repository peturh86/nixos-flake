#!/usr/bin/env bash
set -euo pipefail

# === Configure NixOS Script ===
# Usage: ./scripts/configure.sh <hostname> <kiosk_user> <kiosk_password> <timezone> <locale> <kiosk_url> <wifi_enable> <wifi_ssid> <wifi_password> <wifi_hidden>

HOSTNAME="${1:-kiosk-001}"
KIOSK_USER="${2:-kiosk}"
KIOSK_PASSWORD="${3:-}"
TIMEZONE="${4:-UTC}"
LOCALE="${5:-en_US.UTF-8}"
KIOSK_URL="${6:-https://factory-app.local}"
WIFI_ENABLE="${7:-false}"
WIFI_SSID="${8:-}"
WIFI_PASSWORD="${9:-}"
WIFI_HIDDEN="${10:-false}"

echo "[*] Generating NixOS configuration..."
nixos-generate-config --root /mnt

echo "[*] Creating custom kiosk configuration..."
cat > /mnt/etc/nixos/kiosk-config.nix << EOF
{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./modules/kiosk-base.nix
  ];

  networking.hostName = "$HOSTNAME";

  # Override kiosk settings
  services.kiosk = {
    user = "$KIOSK_USER";
    password = "$KIOSK_PASSWORD";
    timeZone = "$TIMEZONE";
    locale = "$LOCALE";
    kioskUrl = "$KIOSK_URL";
EOF

# Add WiFi configuration if enabled
if [ "$WIFI_ENABLE" = "true" ]; then
  if [ -z "$WIFI_SSID" ]; then
    echo "❌ Error: WIFI_SSID is required when WIFI_ENABLE=true"
    exit 1
  fi
  cat >> /mnt/etc/nixos/kiosk-config.nix << EOF
    wifi = {
      enable = true;
      ssid = "$WIFI_SSID";
      password = "$WIFI_PASSWORD";
      hidden = $WIFI_HIDDEN;
    };
EOF
fi

# Close the services.kiosk block
cat >> /mnt/etc/nixos/kiosk-config.nix << EOF
  };
}
EOF

# Copy the entire modules directory (needed for modular kiosk configuration)
cp -r modules /mnt/etc/nixos/

# Modify the generated configuration.nix to use our custom config
sed -i 's|./hardware-configuration.nix|./kiosk-config.nix|' /mnt/etc/nixos/configuration.nix

echo "[*] NixOS configuration complete!"
