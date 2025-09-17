{ config, lib, ... }:

with lib;

let
  cfg = config.services.kiosk;
in {
  config = {
    environment.etc."xdg/openbox/rc.xml".text = mkIf (! cfg.useCompleteConfig) ''
      <?xml version="1.0" encoding="UTF-8"?>
      <openbox_config xmlns="http://openbox.org/"
                      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                      xsi:schemaLocation="http://openbox.org/
                      file:///usr/share/openbox/rc.xsd">

        <theme>
          <name>Clearlooks</name>
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

        <applications>
          <!-- Firefox in kiosk mode should be full-screen -->
          <application class="firefox" role="browser">
            <decor>no</decor>
            <shade>no</shade>
            <focus>yes</focus>
            <desktop>1</desktop>
            <layer>normal</layer>
            <iconic>no</iconic>
            <skip_pager>no</skip_pager>
            <skip_taskbar>no</skip_taskbar>
            <fullscreen>yes</fullscreen>
            <maximized>true</maximized>
          </application>

          <!-- Other applications should be windowed for Tint2 access -->
          <application class="*">
            <decor>yes</decor>
            <shade>yes</shade>
            <focus>yes</focus>
            <desktop>1</desktop>
            <layer>normal</layer>
            <iconic>no</iconic>
            <skip_pager>no</skip_pager>
            <skip_taskbar>no</skip_taskbar>
            <fullscreen>no</fullscreen>
            <maximized>false</maximized>
          </application>
        </applications>

        <keyboard>
          <chainQuitKey>C-g</chainQuitKey>
          <keybind key="A-F4">
            <action name="Close"/>
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
              <action name="Unshade"/>
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
