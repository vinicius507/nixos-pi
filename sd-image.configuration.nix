{modulesPath, ...}: {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"

    ./modules/locale.nix
    ./modules/networking.nix
    ./modules/users.nix
    ./modules/services/openssh.nix
  ];

  networking.hostName = "nixos-install";
  sdImage.compressImage = false;
  users.mutableUsers = false;

  system.stateVersion = "23.05";
}
