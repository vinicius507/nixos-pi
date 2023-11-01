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
  services.traefik.dynamicConfigOptions = {
    http.routers.adguard.rule = "Host(`adguard.dezano.io`)";
    http.routers.adguard.service = "adguard";
    http.routers.adguard.entryPoints = ["websecure"];
    http.routers.adguard.tls = {};
    http.services.adguard.loadBalancer.servers = [{url = "http://localhost:${toString bind_port}";}];
  };
}
