{
  services.sonarr = {
    enable = true;
    group = "media";
  };
  services.traefik.dynamicConfigOptions = {
    http.routers.sonarr.rule = "Host(`media.dezano.io`) && PathPrefix(`/shows`)";
    http.routers.sonarr.service = "sonarr";
    http.services.sonarr.loadBalancer.servers = [{url = "http://localhost:8989";}];
  };
  systemd.services.sonarr.serviceConfig.UMask = "0007";
}
