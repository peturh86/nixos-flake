{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  options.services.kiosk = {
    user = mkOption {
      type = types.str;
      default = "kiosk";
      description = "Username for the kiosk user";
    };

    password = mkOption {
      type = types.str;
      default = "";
      description = "Password for the kiosk user (empty for passwordless)";
    };

    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [ "wheel" "networkmanager" ];
      description = "Extra groups for the kiosk user";
    };

    autologin = mkOption {
      type = types.bool;
      default = true;
      description = "Enable autologin for the kiosk user";
    };

    kioskUrl = mkOption {
      type = types.str;
      default = "https://factory-app.local";
      description = "URL to open in kiosk mode";
    };

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
    # Kiosk user
    users.users.${cfg.user} = {
      isNormalUser = true;
      extraGroups = cfg.extraGroups;
      password = cfg.password;
    };

    # Console autologin
    services.getty.autologinUser = mkIf cfg.autologin cfg.user;

    # Window manager and kiosk app
    services.xserver.desktopManager.xterm.enable = false;
    services.xserver.windowManager.openbox.enable = true;
    environment.sessionVariables = {
      DEFAULT_SESSION = "${pkgs.firefox}/bin/firefox --kiosk ${cfg.kioskUrl}";
    };

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
