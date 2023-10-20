{modulesPath, ...}: let
  # NOTE: self.outPath leads to infinite recursion (GH: https://github.com/NixOS/nix/issues/9159)
  outPath = ../../.;
in {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    "${outPath}/hosts/shared/locale.nix"
    "${outPath}/hosts/shared/networking.nix"
    "${outPath}/hosts/shared/users.nix"
    "${outPath}/hosts/shared/services/openssh.nix"
    "${outPath}/hosts/shared/services/tailscale.nix"
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
