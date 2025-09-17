{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  config = {
    # Create kiosk user with necessary groups
    users.users."${cfg.user}" = {
      isNormalUser = true;
      description = "Kiosk user";
      initialPassword = cfg.password;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    };

    # User packages
    users.users."${cfg.user}".packages = with pkgs; [
      firefox
      chromium
    ];
  };
}
