{ config, lib, pkgs, ... }:

{
  imports = [
    # Clean module structure: each folder has install.nix + config.nix
    ./openbox/install.nix
    ./openbox/config.nix
    ./tint2/install.nix
    ./tint2/config.nix
    ./system/install.nix
    ./system/config.nix
    ./user/install.nix
    ./user/config.nix
  ];
}