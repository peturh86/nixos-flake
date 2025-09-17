{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    # Tint2 panel and dependencies
    environment.systemPackages = with pkgs; [
      tint2        # Panel/taskbar
    ];
  };
}
