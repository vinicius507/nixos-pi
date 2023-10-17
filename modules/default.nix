{
  core = {
    imports = [
      ./core/locale.nix
      ./core/networking.nix
      ./core/users.nix
    ];
  };
  services = {
    imports = [
      ./services/openssh.nix
    ];
  };
}
