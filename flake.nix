{
  description = "Factory kiosk NixOS configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        kiosk-001 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/kiosk-001/configuration.nix
          ];
        };
      };
    };
}
