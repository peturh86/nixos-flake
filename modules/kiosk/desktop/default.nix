{ config, lib, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  options.services.kiosk = {
    enableLightDM = mkOption {
      type = types.bool;
      default = true;
      description = "Enable LightDM display manager";
    };

    enableTint2 = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Tint2 panel";
    };
  };

  config = {
    # X11 and Display Manager
    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = cfg.enableLightDM;
    services.xserver.displayManager.autoLogin.enable = cfg.autologin;
    services.xserver.displayManager.autoLogin.user = mkIf cfg.autologin cfg.user;
    services.xserver.displayManager.defaultSession = "none+openbox";

    # Window manager and desktop
    services.xserver.desktopManager.xterm.enable = false;
    services.xserver.windowManager.openbox.enable = true;
  };
}
