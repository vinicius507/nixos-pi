{
  imports = [
    ./bazarr.nix
    ./flaresolverr.nix
    ./jellyfin.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./transmission.nix
  ];

  user.groups.media = {};
}
