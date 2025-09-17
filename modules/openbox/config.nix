{ config, pkgs, ... }:

{
  config = {
    # Openbox menu configuration
    environment.etc."xdg/openbox/menu.xml".text = ''
<?xml version="1.0" encoding="UTF-8"?>
<openbox_menu xmlns="http://openbox.org/"
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
<openbox_config xmlns="http://openbox.org/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://openbox.org/
                file:///usr/share/openbox/rc.xsd">

  <theme>
    <name>Onyx</name>
    <titleLayout>NLIMC</titleLayout>
    <keepBorder>yes</keepBorder>
    <animateIconify>yes</animateIconify>
    <font place="ActiveWindow">
      <name>sans</name>
      <size>10</size>
      <weight>bold</weight>
      <slant>normal</slant>
    </font>
    <font place="InactiveWindow">
      <name>sans</name>
      <size>10</size>
      <weight>normal</weight>
      <slant>normal</slant>
    </font>
    <font place="MenuHeader">
      <name>sans</name>
      <size>10</size>
      <weight>normal</weight>
      <slant>normal</slant>
    </font>
    <font place="MenuItem">
      <name>sans</name>
      <size>10</size>
      <weight>normal</weight>
      <slant>normal</slant>
    </font>
    <font place="ActiveOnScreenDisplay">
      <name>sans</name>
      <size>10</size>
      <weight>bold</weight>
      <slant>normal</slant>
    </font>
    <font place="InactiveOnScreenDisplay">
      <name>sans</name>
      <size>10</size>
      <weight>normal</weight>
      <slant>normal</slant>
    </font>
  </theme>

  <desktops>
    <number>1</number>
    <firstdesk>1</firstdesk>
    <names>
      <name>Desktop</name>
    </names>
    <popupTime>0</popupTime>
  </desktops>

  <keyboard>
    <chainQuitKey>C-g</chainQuitKey>
    <keybind key="A-F4">
      <action name="Close"/>
    </keybind>
    <keybind key="A-F10">
      <action name="Maximize"/>
    </keybind>
    <keybind key="A-F9">
      <action name="Iconify"/>
    </keybind>
    <keybind key="A-Escape">
      <action name="Lower"/>
      <action name="FocusToBottom"/>
      <action name="Unfocus"/>
    </keybind>
    <keybind key="C-A-Delete">
      <action name="Exit">
        <prompt>yes</prompt>
      </action>
    </keybind>
  </keyboard>

  <mouse>
    <dragThreshold>1</dragThreshold>
    <doubleClickTime>200</doubleClickTime>
    <screenEdgeWarpTime>400</screenEdgeWarpTime>
    <screenEdgeWarpMouse>false</screenEdgeWarpMouse>

    <context name="Frame">
      <mousebind button="A-Left" action="Press">
        <action name="Focus"/>
        <action name="Raise"/>
      </mousebind>

      <mousebind button="A-Left" action="Click">
        <action name="Unshade"/>
      </mousebind>

      <mousebind button="A-Left" action="Drag">
        <action name="Move"/>
      </mousebind>

      <mousebind button="A-Right" action="Press">
        <action name="Focus"/>
        <action name="Raise"/>
      </mousebind>

      <mousebind button="A-Right" action="Drag">
        <action name="Resize"/>
      </mousebind>
    </context>

    <context name="Desktop">
      <mousebind button="Right" action="Press">
        <action name="ShowMenu">
          <menu>root-menu</menu>
        </action>
      </mousebind>
    </context>
  </mouse>

  <menu>
    <file>/etc/xdg/openbox/menu.xml</file>
    <hideDelay>200</hideDelay>
    <middle>no</middle>
    <submenuShowDelay>100</submenuShowDelay>
    <submenuHideDelay>400</submenuHideDelay>
    <applicationIcons>yes</applicationIcons>
    <manageDesktops>no</manageDesktops>
  </menu>

  <margins>
    <top>0</top>
    <bottom>0</bottom>
    <left>0</left>
    <right>0</right>
  </margins>

  <dock>
    <position>Bottom</position>
    <floatingX>0</floatingX>
    <floatingY>0</floatingY>
    <noStrut>no</noStrut>
    <stacking>Above</stacking>
    <direction>Horizontal</direction>
    <autoHide>no</autoHide>
    <hideDelay>300</hideDelay>
    <showDelay>300</showDelay>
    <moveButton>Middle</moveButton>
  </dock>
</openbox_config>
'';
  };
}