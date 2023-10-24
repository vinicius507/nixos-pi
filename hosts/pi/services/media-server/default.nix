{
  imports = [
    ./bazarr.nix
    ./flaresolverr.nix
    ./jellyfin.nix
    ./prowlarr.nix
    ./sonarr.nix
    ./transmission.nix
  ];

  user.groups.media = {};
}
