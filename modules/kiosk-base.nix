{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  imports = [
    ./kiosk/user/default.nix
    ./kiosk/desktop/default.nix
    ./kiosk/desktop/packages.nix
    ./kiosk/desktop/tint2.nix
    ./kiosk/desktop/tint2-autostart.nix
    ./kiosk/autostart/default.nix
    ./kiosk/system/default.nix
  ];

  options.services.kiosk = {
    # All options are now defined in the individual sub-modules
  };

  config = {
    # Main kiosk configuration is now handled by sub-modules
  };
}