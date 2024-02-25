{config, ...}: {
  virtualisation.oci-containers.containers.code-server = {
    image = "codercom/code-server:latest";
    volumes = [
      "/mnt/storage/data/code-server:/home/coder"
    ];
    ports = ["127.0.0.1:8080:8080"];
  };
  services.traefik.dynamicConfigOptions = {
    http = {
      routers.coder = {
        rule = "Host(`coder.dezano.io`)";
        service = "coder";
        entryPoints = ["websecure"];
      };
      services.coder.loadBalancer.servers = [
        {url = "http://localhost:8080";}
      ];
    };
  };
  systemd.services."${config.virtualisation.oci-containers.backend}-code-server" = {
    after = ["mnt-storage.mount"];
  };
}
