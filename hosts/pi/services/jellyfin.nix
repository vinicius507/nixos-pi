{
  services.jellyfin = {
    enable = true;
    group = "media";
  };
  services.nginx.virtualHosts."jellyfin.dezano.io" = {
    clientMaxBodySize = "20M";
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096";
    };
  };
}
