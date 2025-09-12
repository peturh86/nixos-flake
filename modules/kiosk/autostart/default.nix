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
  };

  config = {
    # Openbox autostart configuration
    environment.etc."xdg/openbox/autostart" = {
      mode = "0755";
      text = ''
        #!/bin/sh
        echo "$(date): Openbox autostart executed" >> /tmp/openbox-autostart.log
        ${pkgs.xorg.xsetroot}/bin/xsetroot -solid '#2a2a2a'
        echo "$(date): Background set" >> /tmp/openbox-autostart.log
      '' + (if cfg.enableTint2 then ''
        echo "$(date): About to start tint2" >> /tmp/openbox-autostart.log
        XDG_CONFIG_DIRS=/etc/xdg ${pkgs.tint2}/bin/tint2 >> /tmp/tint2.log 2>&1 &
        echo "$(date): tint2 command executed" >> /tmp/openbox-autostart.log
      '' else "") + ''
        # Start Firefox in kiosk mode
        echo "$(date): Starting Firefox in kiosk mode" >> /tmp/openbox-autostart.log
        ${pkgs.firefox}/bin/firefox --kiosk ${cfg.kioskUrl} >> /tmp/firefox.log 2>&1 &
        echo "$(date): Firefox started" >> /tmp/openbox-autostart.log
      '' + ''
        echo "$(date): All autostart commands processed" >> /tmp/openbox-autostart.log
      '';
    };
  };
}
