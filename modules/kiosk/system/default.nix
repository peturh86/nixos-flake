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

    system.stateVersion = "25.05";
  };
}
