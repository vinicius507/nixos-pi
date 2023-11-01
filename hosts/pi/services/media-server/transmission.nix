{config, ...}: {
  services.transmission = {
    enable = true;
    group = "media";
    settings = {
      download-dir = "/media/download";
      incomplete-dir-enabled = false;
      rpc-enabled = true;
      rpc-bind-address = "127.0.0.1";
      rpc-host-whitelist = "transmission.dezano.io";
      rpc-host-whitelist-enabled = true;
    };
  };
  services.traefik.dynamicConfigOptions = {
    http.routers.transmission.rule = "Host(`media.dezano.io`) && PathPrefix(`/transmission`)";
    http.routers.transmission.service = "transmission";
    http.services.transmission.loadBalancer.servers = [{url = "http://localhost:${toString config.services.transmission.settings.rpc-port}";}];
  };
  systemd.services.transmission.serviceConfig.MemoryMax = "20%";
}
