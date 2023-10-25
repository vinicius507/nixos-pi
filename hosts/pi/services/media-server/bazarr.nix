{config, ...}: {
  services.bazarr.enable = true;
  users.users.bazarr = {
    extraGroups = ["media"];
  };
  systemd.services.bazarr = {
    serviceConfig.UMask = "0007";
  };
  services.nginx.virtualHosts."bazarr.dezano.io" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.bazarr.listenPort}";
    };
  };
}
