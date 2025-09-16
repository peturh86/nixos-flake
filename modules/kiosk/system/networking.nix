{ config, lib, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  # Networking
  networking.networkmanager.enable = mkDefault true;

  # WiFi configuration
  networking.wireless = mkIf cfg.wifi.enable {
    enable = true;
    userControlled.enable = true;
    networks = mkIf (cfg.wifi.ssid != "") {
      "${cfg.wifi.ssid}" = {
        psk = cfg.wifi.password;
        hidden = cfg.wifi.hidden;
      };
    };
  };

  # NetworkManager WiFi configuration (alternative approach)
  networking.networkmanager = mkIf cfg.wifi.enable {
    wifi = {
      backend = "wpa_supplicant";
      powersave = false;  # Keep WiFi active for kiosk
    };
  };
}
