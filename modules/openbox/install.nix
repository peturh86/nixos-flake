{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    # Openbox window manager and dependencies
    services.xserver.windowManager.openbox.enable = mkDefault true;
    
    # Required packages for Openbox functionality
    environment.systemPackages = with pkgs; [
      openbox      # Window manager
      kdePackages.konsole      # Terminal for menu
      xterm        # Fallback terminal
    ];
  };
}
