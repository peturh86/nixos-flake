{ config, lib, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  # System settings
  time.timeZone = mkDefault cfg.timeZone;
  i18n.defaultLocale = mkDefault cfg.locale;
  console.keyMap = mkDefault cfg.keyMap;
}
