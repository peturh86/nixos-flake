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
      xterm  # Terminal for Openbox menu
      git    # Version control system
  konsole  # KDE terminal emulator
      firefox  # Web browser for kiosk mode
      chromium  # Web browser for SAP and other applications
      wine  # For Windows applications like IPS
      unzip  # Archive utility
      htop  # System monitor
    ];
  };
}
