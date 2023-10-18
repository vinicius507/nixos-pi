{
  lib,
  inputs,
  ...
}: let
  # NOTE: self.outPath leads to infinite recursion (GH: https://github.com/NixOS/nix/issues/9159)
  outPath = ../../.;
in {
  imports = [
    ./hardware-configuration.nix
    "${outPath}/modules/locale.nix"
    "${outPath}/modules/networking.nix"
    "${outPath}/modules/users.nix"
    "${outPath}/modules/services/adguardhome.nix"
    "${outPath}/modules/services/nginx.nix"
    "${outPath}/modules/services/openssh.nix"
  ];

  boot.tmp.useTmpfs = true;

  documentation.man.enable = true;
  documentation.dev.enable = true;

  networking.hostName = "pi";

  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flakes
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];

    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
      substituters = [
        "https://cache.nixos.org/"
        "https://myriad-pi.cachix.org/"
      ];
      trusted-public-keys = [
        "myriad-pi.cachix.org-1:DkbTl3qDCJyNkt5rv8nrNqKAtLdzZMZ1rhagt9kWG9U="
      ];
    };
  };

  system.stateVersion = "23.05";
}
