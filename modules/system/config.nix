{ config, lib, ... }:

with lib;
with types;

let
  cfg = config.services.kiosk;
in {
  options.services.kiosk = {
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
    # X11 and Display Manager
    services.xserver.enable = mkDefault true;
    services.xserver.displayManager.lightdm.enable = mkDefault cfg.enableLightDM;
    services.xserver.displayManager.autoLogin.enable = mkDefault cfg.autologin;
    services.xserver.displayManager.autoLogin.user = mkIf cfg.autologin cfg.user;
    services.xserver.displayManager.defaultSession = mkDefault "none+openbox";

    # Disable xterm desktop manager
    services.xserver.desktopManager.xterm.enable = mkDefault false;

    # Firefox kiosk autostart
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.firefox}/bin/firefox --kiosk ${cfg.kioskUrl} &
    '';
  };
}
