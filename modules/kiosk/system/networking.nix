{ config, lib, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  # Networking configuration
  networking = mkMerge [
    {
      # Base NetworkManager configuration
      networkmanager.enable = mkDefault true;
    }
    (mkIf cfg.wifi.enable {
      # WiFi-specific NetworkManager settings
      networkmanager = {
        wifi = {
          backend = "wpa_supplicant";
          powersave = false;  # Keep WiFi active for kiosk
        };
      };

      # Wireless networking configuration
      wireless = {
        enable = true;
        userControlled.enable = true;
        networks = mkIf (cfg.wifi.ssid != "") {
          "${cfg.wifi.ssid}" = {
            psk = cfg.wifi.password;
            hidden = cfg.wifi.hidden;
          };
        };
      };
    })
  ];
}
