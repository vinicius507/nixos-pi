{config, ...}: {
  services.bazarr = {
    enable = true;
    group = "media";
  };
  services.nginx.virtualHosts."bazarr.dezano.io" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.bazarr.listenPort}";
    };
  };
  systemd.services.bazarr.serviceConfig.UMask = "0007";
}
