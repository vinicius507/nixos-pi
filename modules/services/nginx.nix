{config, ...}: {
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    virtualHosts = {
      "adguard.dezano.io".locations."/".proxyPass = "http://127.0.0.1:${config.services.adguardhome.settings.bind_port}";
    };
  };
}
