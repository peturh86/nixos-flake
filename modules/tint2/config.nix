{ config, pkgs, ... }:

let
  panel     = builtins.readFile ./panel.conf;
  background = builtins.readFile ./background.conf;
  taskbar   = builtins.readFile ./taskbar.conf;
  task      = builtins.readFile ./task.conf;
  systray   = builtins.readFile ./systray.conf;
  launcher  = builtins.readFile ./launcher.conf;
  clock     = builtins.readFile ./clock.conf;
  battery   = builtins.readFile ./battery.conf;
  tooltip   = builtins.readFile ./tooltip.conf;
in {
  environment.etc."xdg/tint2/tint2rc".text = ''
  
    ${panel}

    ${background}

    ${taskbar}

    ${task}

    ${systray}

    ${launcher}

    ${clock}

    ${battery}

    ${tooltip}

  '';

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.tint2}/bin/tint2 &
  '';
}
