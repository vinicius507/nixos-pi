{
  services.radarr = {
    enable = true;
    group = "media";
  };
  services.traefik.dynamicConfigOptions = {
    http.routers.radarr.rule = "Host(`movies.dezano.io`)";
    http.routers.radarr.service = "radarr";
    http.routers.radarr.entryPoints = ["websecure"];
    http.routers.radarr.tls = {};
    http.services.radarr.loadBalancer.servers = [{url = "http://localhost:7878";}];
  };
  systemd.services.radarr.serviceConfig.UMask = "0007";
}
