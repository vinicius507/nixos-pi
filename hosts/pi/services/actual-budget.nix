{config, ...}: {
  virtualisation.oci-containers.containers.actual-budget = {
    image = "actualbudget/actual-server:latest-alpine";
    volumes = [
      "/mnt/storage/data/actual-budget:/home/coder"
    ];
    ports = ["127.0.0.1:5006:5006"];
  };
  services.traefik.dynamicConfigOptions = {
    http = {
      routers.actual = {
        rule = "Host(`actual.dezano.io`)";
        service = "actual";
        entryPoints = ["websecure"];
      };
      services.actual.loadBalancer.servers = [
        {url = "http://localhost:5006";}
      ];
    };
  };
  systemd.services."${config.virtualisation.oci-containers.backend}-actual-budget" = {
    after = ["mnt-storage.mount"];
  };
}