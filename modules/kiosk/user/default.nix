{ config, lib, ... }:

with lib;
with types;

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
  };
}
