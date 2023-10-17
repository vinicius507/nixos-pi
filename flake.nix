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
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
      ];
      specialArgs = {inherit inputs;};
    };
    nixosModules = import ./modules;
  };
}
