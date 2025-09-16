{ hostname ? "kiosk-001", ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/kiosk-base.nix
  ];

  networking.hostName = hostname;

  # WiFi configuration example (uncomment and modify as needed)
  # services.kiosk.wifi = {
  #   enable = true;
  #   ssid = "YourWiFiNetwork";
  #   password = "YourWiFiPassword";
  #   hidden = false;  # Set to true if network is hidden
  # };
}
