{ config, lib, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  config = {
    # User-specific configuration (if needed)
    # Currently handled by system/config.nix and autostart
  };
}
