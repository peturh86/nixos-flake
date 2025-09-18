{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.makeDesktopItem {
      name = "web";
      desktopName = "Web";
      exec = "firefox --new-window https://www.ja.is";
      icon = "firefox";
      categories = [ "Network" ];
    })
    (pkgs.makeDesktopItem {
      name = "sap";
      desktopName = "SAP (Web)";
      exec = "chromium --app=https://sapapp-p1.postur.is/sap/bc/gui/sap/its/webgui";
      icon = "chromium";
      categories = [ "Network" ];
    })
  ];
}
