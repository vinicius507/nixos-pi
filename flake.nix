{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
  } @ inputs: let
    system = "aarch64-linux";
  in {
    packages.${system} = {
      default = self.nixosConfigurations.pi.config.system.build.toplevel;
      sd-image = self.nixosConfigurations.sd-image.config.system.build.sdImage;
    };
    nixosConfigurations = {
      pi = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/pi
          nixos-hardware.nixosModules.raspberry-pi-4
        ];
        specialArgs = {inherit inputs;};
      };
      sd-image = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/sd-image
          nixos-hardware.nixosModules.raspberry-pi-4
        ];
      };
    };
  };
}
