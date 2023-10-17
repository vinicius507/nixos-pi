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
      ./services/adguardhome.nix
      ./services/nginx.nix
      ./services/openssh.nix
    ];
  };
}
