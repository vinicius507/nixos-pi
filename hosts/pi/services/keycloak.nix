{config, ...}: let
  http-port = 8001;
in {
  services.keycloak = {
    enable = true;
    database = {
      type = "postgresql";
      passwordFile = config.sops.secrets."services/keycloak/db-password".path;
    };
    settings = {
      inherit http-port;
      hostname = "auth.dezano.io";
      proxy = "edge";
      http-host = "127.0.0.1";
    };
  };
  services.traefik.dynamicConfigOptions = {
    http.routers.keycloak = {
      rule = "Host(`auth.dezano.io`)";
      service = "keycloak";
      entryPoints = ["websecure"];
    };
    http.services.keycloak.loadBalancer.servers = [{url = "http://localhost:${toString http-port}";}];
  };
  sops.secrets."services/keycloak/db-password" = {
    restartUnits = ["keycloak.service"];
  };
}
