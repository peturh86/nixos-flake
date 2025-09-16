{ config, pkgs, ... }:
{
  # Import desktop entries and tint2 config from complete-config
  imports = [
    ../../complete-config/modules/panel/tint2-config.nix
    ../../complete-config/modules/ui/openbox-menu.nix
    ../../complete-config/modules/panel/tint2-packages.nix
  ];
}
