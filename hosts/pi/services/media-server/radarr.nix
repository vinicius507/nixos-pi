{
  services.radarr = {
    enable = true;
    group = "media";
  };
  services.nginx.virtualHosts."radarr.dezano.io" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:7878";
    };
  };
  systemd.services.radarr.serviceConfig.UMask = "0007";
}
