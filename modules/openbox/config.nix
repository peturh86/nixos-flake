{ config, pkgs, lib, ... }:

let
  theme        = builtins.readFile ./theme.xml;
  keyboard     = builtins.readFile ./keyboard.xml;
  mouse        = builtins.readFile ./mouse.xml;
  dock         = builtins.readFile ./dock.xml;
  menuSection  = builtins.readFile ./menu-section.xml;
in {
  environment.etc = {
    "xdg/openbox/rc.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <openbox_config xmlns="http://openbox.org/">

        <!-- Theme & desktops -->
        ${theme}

        <!-- Keyboard shortcuts -->
        ${keyboard}

        <!-- Mouse bindings -->
        ${mouse}

        <!-- Menus -->
        ${menuSection}

        <!-- Dock -->
        ${dock}

      </openbox_config>
    '';

    # Copy the standalone menu definitions
    "xdg/openbox/menu-user.xml".source  = ./menu-user.xml;
    "xdg/openbox/menu-admin.xml".source = ./menu-admin.xml;
  };
}
