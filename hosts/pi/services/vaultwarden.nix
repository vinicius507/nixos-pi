{config, ...}: {
  virtualisation.oci-containers.containers.vaultwarden = {
    image = "vaultwarden/server:1.32.0-alpine@sha256:e3efdc8a9961643f5f0d2c72596aedfe4b4fcfce9836e18c1e8ba0b8c2e06459";
    volumes = [
      "/mnt/storage/data/vaultwarden:/data"
    ];
    ports = ["127.0.0.1:3002:80"];
    environment = {
      DOMAIN = "https://vault.dezano.io";
      SIGNUPS_ALLOWED = "true";
    };
  };
  services.traefik.dynamicConfigOptions = {
    http = {
      routers.vaultwarden = {
        rule = "Host(`vault.dezano.io`)";
        service = "vaultwarden";
        entryPoints = ["websecure"];
      };
      services.vaultwarden.loadBalancer.servers = [
        {url = "http://localhost:3002";}
      ];
    };
  };
  systemd.services."${config.virtualisation.oci-containers.backend}-vaultwarden" = {
    after = ["mnt-storage.mount"];
  };
}
