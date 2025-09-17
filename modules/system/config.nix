{ config, lib, ... }:

with lib;
with types;

let
  cfg = config.services.kiosk;
in {
  config = {
    # X11 and Display Manager
    services.xserver.enable = mkDefault true;
    services.xserver.displayManager.lightdm.enable = mkDefault cfg.enableLightDM;
    services.xserver.displayManager.autoLogin.enable = mkDefault cfg.autologin;
    services.xserver.displayManager.autoLogin.user = mkIf cfg.autologin cfg.user;
    services.xserver.displayManager.defaultSession = mkDefault "none+openbox";

    # Disable xterm desktop manager
    services.xserver.desktopManager.xterm.enable = mkDefault false;
  };
}
