{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/kiosk-base.nix
  ];

  networking.hostName = "kiosk-001";
}
