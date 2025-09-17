{ config, pkgs, ... }:

{
  # Openbox menu configuration
  environment.etc."xdg/openbox/menu.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <openbox_menu
      xmlns="http://openbox.org/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://openbox.org/
                  file:///usr/share/openbox/menu.xsd">

      <menu id="root-menu" label="Menu">
        <!-- Your 3 kiosk applications -->
        <item label="Web Browser">
          <action name="Execute">
            <command>firefox --new-window https://www.ja.is</command>
          </action>
        </item>

        <item label="IPS">
          <action name="Execute">
            <command>ips</command>
          </action>
        </item>

        <item label="SAP">
          <action name="Execute">
            <command>chromium --app=https://sapapp-p1.postur.is/sap/bc/gui/sap/its/webgui</command>
          </action>
        </item>

        <separator />

        <!-- Debug tools -->
        <menu id="debug-menu" label="Debug Tools">
          <item label="Terminal">
            <action name="Execute">
              <command>konsole</command>
            </action>
          </item>

          <item label="IPS Debug">
            <action name="Execute">
              <command>konsole -e sh -c 'ips-debug; echo "Press Enter to close..."; read'</command>
            </action>
          </item>

          <item label="IPS Status">
            <action name="Execute">
              <command>konsole -e sh -c 'ips-status; echo "Press Enter to close..."; read'</command>
            </action>
          </item>

          <item label="Wine Config">
            <action name="Execute">
              <command>konsole -e sh -c 'export WINEPREFIX=$HOME/.wine-ips; winecfg'</command>
            </action>
          </item>
        </menu>

        <separator />

        <!-- System controls -->
        <item label="Reboot">
          <action name="Execute">
            <command>systemctl reboot</command>
          </action>
        </item>
      </menu>
    </openbox_menu>
  '';

  # Openbox configuration
  environment.etc."xdg/openbox/rc.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <openbox_config
      xmlns="http://openbox.org/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://openbox.org/
                    file:///usr/share/openbox/rc.xsd">

      <!-- Windows-like theme with titlebar buttons -->
      <theme>
        <name>Onyx</name>
        <titleLayout>NLIMC</titleLayout>
      </theme>

      <!-- Single desktop -->
      <desktops>
        <number>1</number>
        <firstdesk>1</firstdesk>
        <names>
          <name>Desktop</name>
        </names>
        <popupTime>0</popupTime>
      </desktops>

      <!-- Basic Windows-like keyboard shortcuts -->
      <keyboard>
        <keybind key="A-F4"><action name="Close" /></keybind>
        <keybind key="A-F10"><action name="Maximize" /></keybind>
        <keybind key="A-F9"><action name="Iconify" /></keybind>
      </keyboard>

      <!-- Attach the custom menu -->
      <menu>
        <file>/etc/xdg/openbox/menu.xml</file>
        <hideDelay>200</hideDelay>
        <middle>no</middle>
        <submenuShowDelay>100</submenuShowDelay>
        <submenuHideDelay>400</submenuHideDelay>
        <applicationIcons>yes</applicationIcons>
        <manageDesktops>no</manageDesktops>
      </menu>

      <!-- Dock: keep tint2 at bottom -->
      <dock>
        <position>Bottom</position>
        <stacking>Above</stacking>
        <direction>Horizontal</direction>
      </dock>
    </openbox_config>
  '';
}
