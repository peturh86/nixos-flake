{
  description = "Factory kiosk NixOS configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";

      # Function to create a kiosk configuration
      mkKioskConfig = hostname: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/${hostname}/configuration.nix
        ];
        specialArgs = {
          inherit hostname;
        };
      };
    in {
      nixosConfigurations = {
        # Default kiosk configuration
        kiosk-001 = mkKioskConfig "kiosk-001";

        # You can add more hosts here:
        # kiosk-002 = mkKioskConfig "kiosk-002";
        # kiosk-003 = mkKioskConfig "kiosk-003";
      };

      # Template for new kiosk hosts
      templates = {
        kiosk = {
          description = "Basic kiosk configuration template";
          path = ./hosts/kiosk-001;
        };
      };
    };
}
