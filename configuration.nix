{
  lib,
  inputs,
  ...
}: {
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

  system.stateVersion = "23.11";
}
