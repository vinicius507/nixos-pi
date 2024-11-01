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

    ./services/adguardhome.nix
    ./services/coolify.nix
    ./services/step-ca.nix

    "${outPath}/hosts/shared/locale.nix"
    "${outPath}/hosts/shared/networking.nix"
    "${outPath}/hosts/shared/users.nix"
    "${outPath}/hosts/shared/services/openssh.nix"
    "${outPath}/hosts/shared/services/tailscale.nix"
  ];

  boot.tmp.useTmpfs = true;

  documentation.man.enable = true;
  documentation.dev.enable = true;

  networking = {
    hostName = "pi";
    firewall = {
      trustedInterfaces = ["docker0"];
      extraCommands = ''
        iptables -A nixos-fw -p tcp --source 192.168.1.0/24 --dport 80,443 -j nixos-fw-accept
        iptables -A nixos-fw -p udp --source 192.168.1.0/24 --dport 80,443 -j nixos-fw-accept
      '';
      extraStopCommands = ''
        iptables -D nixos-fw -p tcp --source 192.168.1.0/24 --dport 80,443 -j nixos-fw-accept || true
        iptables -D nixos-fw -p udp --source 192.168.1.0/24 --dport 80,443 -j nixos-fw-accept || true
      '';
    };
  };

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

  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };

  sops.defaultSopsFile = ../../secrets/default.yaml;

  system.stateVersion = "23.05";
}
