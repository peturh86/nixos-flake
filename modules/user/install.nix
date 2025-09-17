{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  config = {
    # Create kiosk user with necessary groups and packages
    users.users."${cfg.user}" = {
      isNormalUser = true;
      description = "Kiosk user";
      initialPassword = lib.mkIf (cfg.password != "") cfg.password;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" ];

      packages = with pkgs; [
        firefox
        chromium
      ];
    };
  };
}