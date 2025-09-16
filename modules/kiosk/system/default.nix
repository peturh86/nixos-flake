{ config, lib, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  options.services.kiosk = {
    timeZone = mkOption {
      type = types.str;
      default = "UTC";
      description = "System time zone";
    };

    locale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = "System locale";
    };

    keyMap = mkOption {
      type = types.str;
      default = "us";
      description = "Console keymap";
    };

    wifi = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable WiFi configuration";
      };

      ssid = mkOption {
        type = types.str;
        default = "";
        description = "WiFi network name (SSID)";
      };

      password = mkOption {
        type = types.str;
        default = "";
        description = "WiFi network password";
      };

      hidden = mkOption {
        type = types.bool;
        default = false;
        description = "Whether the WiFi network is hidden";
      };
    };
  };

  config = {
    # Essential system packages
    environment.systemPackages = with pkgs; [
      # Basic utilities
      git
      vim
      wget
      curl
      htop
      tmux

      # Networking tools
      networkmanager
      wpa_supplicant
      iw
      wireless-tools

      # System monitoring
      pciutils
      usbutils
      lshw
    ];

    # Remote management
    services.openssh.enable = mkDefault true;

    # Boot loader
    boot.loader.systemd-boot.enable = mkDefault true;
    boot.loader.efi.canTouchEfiVariables = mkDefault true;

    # System settings
    time.timeZone = mkDefault cfg.timeZone;
    i18n.defaultLocale = mkDefault cfg.locale;
    console.keyMap = mkDefault cfg.keyMap;

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

    system.stateVersion = "25.05";
  };
}
