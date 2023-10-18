{modulesPath, ...}: let
  # NOTE: self.outPath leads to infinite recursion (GH: https://github.com/NixOS/nix/issues/9159)
  outPath = ../../.;
in {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    "${outPath}/modules/locale.nix"
    "${outPath}/modules/networking.nix"
    "${outPath}/modules/users.nix"
    "${outPath}/modules/services/openssh.nix"
  ];

  users.mutableUsers = false;
  networking.hostName = "nixos-install";
  nixpkgs = {
    hostPlatform = "aarch64-linux";
    overlays = [
      (final: prev: {
        makeModulesClosure = x: prev.makeModulesClosure (x // {allowMissing = true;});
      })
    ];
  };

  system.stateVersion = "23.05";
}
