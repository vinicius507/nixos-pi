{
  services.prowlarr.enable = true;
  services.traefik.dynamicConfigOptions = {
    http.routers.prowlarr.rule = "Host(`prowlarr.dezano.io`)";
    http.routers.prowlarr.service = "prowlarr";
    http.routers.prowlarr.entryPoints = ["websecure"];
    http.routers.prowlarr.tls = {};
    http.services.prowlarr.loadBalancer.servers = [{url = "http://localhost:9696";}];
  };
}
