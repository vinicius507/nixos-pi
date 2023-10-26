let
  bind_port = 3000;
in {
  services.adguardhome = {
    enable = true;
    settings = {
      inherit bind_port;
      dns = {
        bind_hosts = [
          "127.0.0.1"
          "100.72.47.143"
        ];
        ratelimit = 100;
      };
    };
  };
  services.nginx.virtualHosts."adguard.dezano.io" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString bind_port}";
    };
  };
}
