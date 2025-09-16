{ config, lib, ... }:

with lib;

{
  # Boot loader
  boot.loader.systemd-boot.enable = mkDefault true;
  boot.loader.efi.canTouchEfiVariables = mkDefault true;
}
