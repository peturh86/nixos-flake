{ config, lib, ... }:

with lib;
with types;

let
  cfg = config.services.kiosk;
in {
  imports = [
    ./packages.nix
    ./networking.nix
    ./boot.nix
    ./settings.nix
  ];

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
    # Enable essential programs
    programs.firefox.enable = mkDefault true;
    programs.chromium.enable = mkDefault true;
    programs.git.enable = mkDefault true;

    # Remote management
    services.openssh.enable = mkDefault true;

    system.stateVersion = "25.05";
  };
}
