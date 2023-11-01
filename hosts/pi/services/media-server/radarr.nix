{
  services.radarr = {
    enable = true;
    group = "media";
  };
  services.traefik.dynamicConfigOptions = {
    http.routers.radarr.rule = "Host(`media.dezano.io`) && PathPrefix(`/movies`)";
    http.routers.radarr.service = "radarr";
    http.services.radarr.loadBalancer.servers = [{url = "http://localhost:7878";}];
  };
  systemd.services.radarr.serviceConfig.UMask = "0007";
}
