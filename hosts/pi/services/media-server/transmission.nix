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
  services.nginx.virtualHosts."transmission.dezano.io" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.transmission.settings.rpc-port}";
    };
  };
  systemd.services.transmission.serviceConfig.MemoryMax = "20%";
}
