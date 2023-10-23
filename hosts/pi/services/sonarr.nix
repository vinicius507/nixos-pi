{
  services.sonarr = {
    enable = true;
    group = "media";
  };
  services.nginx.virtualHosts."sonarr.dezano.io" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8989";
    };
  };
}
