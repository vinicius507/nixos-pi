{
  lib,
  inputs,
  ...
}: let
  inherit (inputs) nixpkgs nixos-hardware;
in {
  imports = [
    nixos-hardware.nixosModules.raspberry-pi-4
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
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
        "https://vinicius507.cachix.org/"
      ];
      trusted-public-keys = [
        "vinicius507.cachix.org-1:cWsivfWENRKZ19obQM96XtSKha88BEuQWQt+qEFFnYE="
      ];
    };
  };

  sdImage.compressImage = false;

  system.stateVersion = "23.11";
}
