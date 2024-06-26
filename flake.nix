{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  nixConfig = {
    extra-substituters = "https://myriad-pi.cachix.org";
    extra-trusted-public-keys = "myriad-pi.cachix.org-1:DkbTl3qDCJyNkt5rv8nrNqKAtLdzZMZ1rhagt9kWG9U=";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    sops-nix,
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
          sops-nix.nixosModules.sops
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
