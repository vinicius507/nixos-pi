{config, ...}: {
  services.transmission = {
    enable = true;
    group = "media";
    settings = {
      download-dir = "/media/download";
      incomplete-dir = "/media/download/.incomplete";
      rpc-enabled = true;
      rpc-whitelist = "127.0.0.1";
      rpc-whitelist-enabled = true;
      rpc-host-whitelist = "transmission.dezano.io";
      rpc-host-whitelist-enabled = true;
    };
  };
  systemd.services.transmission.serviceConfig.MemoryMax = "20%";
  services.nginx.virtualHosts."transmission.dezano.io" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.transmission.port}";
    };
  };
}
