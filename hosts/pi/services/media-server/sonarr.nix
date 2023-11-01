{
  services.sonarr = {
    enable = true;
    group = "media";
  };
  services.traefik.dynamicConfigOptions = {
    http.routers.sonarr.rule = "Host(`shows.dezano.io`)";
    http.routers.sonarr.service = "sonarr";
    http.routers.sonarr.entryPoints = ["websecure"];
    http.routers.sonarr.tls = {};
    http.services.sonarr.loadBalancer.servers = [{url = "http://localhost:8989";}];
  };
  systemd.services.sonarr.serviceConfig.UMask = "0007";
}
