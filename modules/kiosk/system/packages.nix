{ config, lib, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  # Essential system packages
  environment.systemPackages = with pkgs; [
    # Basic utilities
    git
    vim
    wget
    curl
    htop
    tmux

    # Networking tools
    networkmanager
    wpa_supplicant
    iw
    wireless-tools

    # System monitoring
    pciutils
    usbutils
    lshw
  ];
}
