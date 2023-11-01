{
  services.prowlarr.enable = true;
  services.traefik.dynamicConfigOptions = {
    http.routers.prowlarr.rule = "Host(`media.dezano.io`) && PathPrefix(`/indexers`)";
    http.routers.prowlarr.service = "prowlarr";
    http.services.prowlarr.loadBalancer.servers = [{url = "http://localhost:9696";}];
  };
}
