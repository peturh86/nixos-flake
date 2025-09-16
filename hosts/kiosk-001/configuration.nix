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

  # To prefer the complete-config Openbox and Tint2 settings (icons + menu),
  # enable the following option. This will cause the kiosk modules to skip
  # writing their default menu/tint2 files and let the imported complete-config
  # versions take precedence.
  # services.kiosk.useCompleteConfig = true;
}
