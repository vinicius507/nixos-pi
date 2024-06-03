let
  port = 3000;
in {
  services.adguardhome = {
    enable = true;
    settings = {
      inherit port;
      dns = {
        bind_hosts = [
          "127.0.0.1"
          "100.75.27.122"
        ];
        ratelimit = 100;
      };
    };
  };
  services.traefik.dynamicConfigOptions = {
    http.routers.adguard.rule = "Host(`adguard.dezano.io`)";
    http.routers.adguard.service = "adguard";
    http.routers.adguard.entryPoints = ["websecure"];
    http.services.adguard.loadBalancer.servers = [{url = "http://localhost:${toString port}";}];
  };
}
