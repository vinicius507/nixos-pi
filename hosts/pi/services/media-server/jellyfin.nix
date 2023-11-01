{lib, ...}: {
  services.jellyfin = {
    enable = true;
    group = "media";
  };
  services.traefik.dynamicConfigOptions = {
    http.routers.jellyfin.rule = "Host(`media.dezano.io`) && PathPrefix(`/stream`)";
    http.routers.jellyfin.service = "jellyfin";
    http.services.jellyfin.loadBalancer.servers = [{url = "http://localhost:8096";}];
  };
  systemd.services.jellyfin.serviceConfig.UMask = lib.mkForce "0007";
}
