{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kiosk;

  # Create desktop entries for launcher items
  firefoxKiosk = pkgs.makeDesktopItem {
    name = "firefox-kiosk";
    desktopName = "Firefox Kiosk";
    exec = "firefox --kiosk ${cfg.kioskUrl}";
    icon = "firefox";
    categories = [ "Network" ];
  };

  konsole = pkgs.makeDesktopItem {
    name = "konsole-terminal";
    desktopName = "Konsole";
    exec = "konsole";
    icon = "konsole";
    categories = [ "TerminalEmulator" ];
  };

  xterm = pkgs.makeDesktopItem {
    name = "xterm-terminal";
    desktopName = "XTerm";
    exec = "xterm";
    icon = "xterm";
    categories = [ "TerminalEmulator" ];
  };
in {
  config = {
    # Add desktop entries to system packages so they're available
    environment.systemPackages = [
      firefoxKiosk
      konsole
      xterm
    ];
  };
}
