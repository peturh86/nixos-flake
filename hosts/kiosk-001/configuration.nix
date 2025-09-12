{ hostname ? "kiosk-001", ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/kiosk-base.nix
  ];

  networking.hostName = hostname;
}
