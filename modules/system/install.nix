{ config, lib, pkgs, ... }:

with lib;
with types;

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

    enableLightDM = mkOption {
      type = types.bool;
      default = true;
      description = "Enable LightDM display manager";
    };

    user = mkOption {
      type = types.str;
      default = "kiosk";
      description = "Kiosk user name";
    };

    password = mkOption {
      type = types.str;
      default = "";
      description = "Kiosk user password";
    };

    autologin = mkOption {
      type = types.bool;
      default = true;
      description = "Enable automatic login";
    };

    kioskUrl = mkOption {
      type = types.str;
      default = "https://factory-app.local";
      description = "URL for kiosk mode Firefox";
    };
  };

  config = {
    # Essential system packages
    environment.systemPackages = with pkgs; [
      git           # Version control
      firefox       # Web browser for kiosk mode
      chromium      # Web browser for SAP and other applications  
      wine          # For Windows applications like IPS
      unzip         # Archive utility
      htop          # System monitor
      networkmanager # Network management
      wpa_supplicant # WiFi support
      iw            # Wireless tools
      wirelesstools # Additional wireless utilities
      lshw          # Hardware info
      networkmanagerapplet # NetworkManager GUI
    ];

    # Enable essential programs
    programs.firefox.enable = mkDefault true;
    programs.chromium.enable = mkDefault true;
    programs.git.enable = mkDefault true;

    # Remote management
    services.openssh.enable = mkDefault true;

    # Boot configuration
    boot.loader.systemd-boot.enable = mkDefault true;
    boot.loader.efi.canTouchEfiVariables = mkDefault true;

    # System settings
    time.timeZone = mkDefault cfg.timeZone;
    i18n.defaultLocale = mkDefault cfg.locale;
    console.keyMap = mkDefault cfg.keyMap;

    # Networking with WiFi support
    networking = mkMerge [
      {
        networkmanager.enable = mkDefault true;
        wireless.enable = mkDefault false;
      }
      (mkIf cfg.wifi.enable {
        networkmanager.ensureProfiles.profiles."${cfg.wifi.ssid}" = {
          connection = {
            id = cfg.wifi.ssid;
            type = "wifi";
            autoconnect = true;
          };
          wifi = {
            mode = "infrastructure";
            ssid = cfg.wifi.ssid;
            hidden = cfg.wifi.hidden;
          };
          wifi-security = mkIf (cfg.wifi.password != "") {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = cfg.wifi.password;
          };
        };
      })
    ];

    system.stateVersion = "25.05";
  };
}
