{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  options.services.kiosk = {
    kioskUrl = mkOption {
      type = types.str;
      default = "https://factory-app.local";
      description = "URL to open in kiosk mode";
    };

    autostart = {
      lines = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Lines to add to /etc/xdg/openbox/autostart";
      };
    };
  };

  config = {
    # Openbox autostart configuration
    environment.etc."xdg/openbox/autostart" = {
      mode = "0755";
      text = concatStringsSep "\n" (
        [
          "#!/bin/sh"
          "echo \"$(date): Openbox autostart executed\" >> /tmp/openbox-autostart.log"
          "${pkgs.xorg.xsetroot}/bin/xsetroot -solid '#2a2a2a'"
          "echo \"$(date): Background set\" >> /tmp/openbox-autostart.log"
        ] ++ (map (l: l) (lib.unique config.services.kiosk.autostart.lines)) ++ [
          "# Start Firefox in kiosk mode"
          "echo \"$(date): Starting Firefox in kiosk mode\" >> /tmp/openbox-autostart.log"
          "${pkgs.firefox}/bin/firefox --kiosk ${cfg.kioskUrl} >> /tmp/firefox.log 2>&1 &"
          "echo \"$(date): Firefox started\" >> /tmp/openbox-autostart.log"
          "echo \"$(date): All autostart commands processed\" >> /tmp/openbox-autostart.log"
        ]
      ) + "\n";
    };

    # Ensure Tint2 starts with X session
    services.xserver.displayManager.sessionCommands = ''
      # Set background
      ${pkgs.xorg.xsetroot}/bin/xsetroot -solid '#2a2a2a'

      # Start tint2
      XDG_CONFIG_DIRS=/etc/xdg ${pkgs.tint2}/bin/tint2 &

      # Log for debugging
      echo "$(date): X session commands executed" >> /tmp/x-session.log
    '';
  };
}
