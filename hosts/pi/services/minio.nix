{config, ...}: {
  services.minio = {
    enable = true;
    listenAddress = ":8002";
    consoleAddress = ":3002";
    dataDir = ["/mnt/storage/data/minio"];
    configDir = "/mnt/storage/config/minio";
    rootCredentialsFile = config.sops.secrets."services/minio/root-credentials".path;
    region = "sa-east-1";
  };
  services.traefik.dynamicConfigOptions = {
    http = {
      routers = {
        minio = {
          rule = "Host(`storage.dezano.io`)";
          service = "minio";
          entryPoints = ["websecure"];
        };
        minio-console = {
          rule = "Host(`minio.dezano.io`)";
          service = "minio-console";
          entryPoints = ["websecure"];
        };
      };
      services = {
        minio.loadBalancer.servers = [
          {url = "http://localhost:8002";}
        ];
        minio-console.loadBalancer.servers = [
          {url = "http://localhost:3002";}
        ];
      };
    };
  };
  systemd.services.minio = {
    after = ["mnt-storage.mount"];
  };
  sops.secrets."services/minio/root-credentials" = {
    owner = config.users.users.minio.name;
    group = config.users.users.minio.group;
  };
}
