{
  services.prowlarr.enable = true;
  services.nginx.virtualHosts."prowlarr.dezano.io" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:9696";
    };
  };
}
