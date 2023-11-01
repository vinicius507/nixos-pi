{config, ...}: {
  services.bazarr = {
    enable = true;
    group = "media";
  };
  services.traefik.dynamicConfigOptions = {
    http.routers.bazarr.rule = "Host(`media.dezano.io`) && PathPrefix(`/subs`)";
    http.routers.bazarr.service = "bazarr";
    http.services.bazarr.loadBalancer.servers = [{url = "http://localhost:${toString config.services.bazarr.listenPort}";}];
  };
  systemd.services.bazarr.serviceConfig.UMask = "0007";
}
