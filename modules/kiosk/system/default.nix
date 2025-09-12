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
  };

  config = {
    # Remote management
    services.openssh.enable = true;

    # Boot loader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # System settings
    time.timeZone = cfg.timeZone;
    i18n.defaultLocale = cfg.locale;
    console.keyMap = cfg.keyMap;

    # Networking
    networking.networkmanager.enable = true;

    system.stateVersion = "25.05";
  };
}
