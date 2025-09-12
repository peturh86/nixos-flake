{ config, pkgs, ... }:

{
  # One dedicated user
  users.users.kiosk = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    password = ""; # passwordless
  };

  # Console autologin
  services.getty.autologinUser = "kiosk";

  # X11 kiosk session
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kiosk";

  # Replace with your real kiosk app:
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.windowManager.openbox.enable = true;
  environment.sessionVariables = {
    DEFAULT_SESSION = "${pkgs.firefox}/bin/firefox --kiosk https://factory-app.local";
  };

  # Remote management
  services.openssh.enable = true;

  system.stateVersion = "25.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
