{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  config = {
    # Additional packages for desktop environment
    environment.systemPackages = with pkgs; [
      openbox
      tint2
      xorg.xsetroot
      xorg.xprop
      wmctrl
      xdotool
    ];
  };
}
