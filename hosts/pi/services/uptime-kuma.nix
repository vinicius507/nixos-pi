{
  config,
  lib,
  ...
}: {
  services.uptime-kuma = {
    enable = true;
    settings = {
      DATA_DIR = lib.mkForce "/mnt/storage/data/uptime-kuma";
      NODE_EXTRA_CA_CERTS = config.sops.secrets."services/step-ca/root-cert".path;
    };
  };
  services.traefik.dynamicConfigOptions = {
    http = {
      routers.uptime-kuma = {
        rule = "Host(`status.dezano.io`)";
        service = "uptime-kuma";
        entryPoints = ["websecure"];
      };
      services.uptime-kuma.loadBalancer.servers = [
        {url = "http://localhost:5230";}
      ];
    };
  };
  systemd.services.uptime-kuma = {
    after = ["mnt-storage.mount"];
  };
}
