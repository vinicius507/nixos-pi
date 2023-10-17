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
    nixosConfigurations.pi = nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [
          nixos-hardware.nixosModules.raspberry-pi-4
          ./hardware-configuration.nix
          ./configuration.nix
        ]
        ++ builtins.attrValues self.nixosModules;
      specialArgs = {inherit inputs;};
    };
    nixosModules = import ./modules;
  };
}
