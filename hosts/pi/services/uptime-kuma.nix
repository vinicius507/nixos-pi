{config, ...}: {
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = "3003";
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
        {url = "http://localhost:3003";}
      ];
    };
  };
  systemd.services.uptime-kuma = {
    after = ["mnt-storage.mount"];
  };
}
