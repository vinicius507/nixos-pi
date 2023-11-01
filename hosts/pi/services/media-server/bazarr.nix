{config, ...}: {
  services.bazarr = {
    enable = true;
    group = "media";
  };
  services.traefik.dynamicConfigOptions = {
    http.routers.bazarr.rule = "Host(`subs.dezano.io`)";
    http.routers.bazarr.service = "bazarr";
    http.routers.bazarr.entryPoints = ["websecure"];
    http.routers.bazarr.tls = {};
    http.services.bazarr.loadBalancer.servers = [{url = "http://localhost:${toString config.services.bazarr.listenPort}";}];
  };
  systemd.services.bazarr.serviceConfig.UMask = "0007";
}
