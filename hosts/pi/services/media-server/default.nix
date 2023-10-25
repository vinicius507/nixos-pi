{
  imports = [
    ./bazarr.nix
    ./flaresolverr.nix
    ./flood.nix
    ./jellyfin.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./transmission.nix
  ];

  users.groups.media = {};
}
