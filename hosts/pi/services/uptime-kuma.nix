{config, ...}: {
  services.uptime-kuma = {
    enable = true;
    settings = {
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
        {url = "http://localhost:4000";}
      ];
    };
  };
  systemd.services.uptime-kuma = {
    after = ["mnt-storage.mount"];
  };
}
