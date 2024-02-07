{config, ...}: {
  virtualisation.oci-containers.containers.memos = {
    image = "neosmemo/memos:stable";
    volumes = [
      "/mnt/storage/data/memos:/var/opt/memos"
      "${config.sops.secrets."services/step-ca/root-cert".path}:/etc/ssl/certs/step-ca-root-cert.crt:ro"
    ];
    ports = ["127.0.0.1:5230:5230"];
  };
  services.traefik.dynamicConfigOptions = {
    http = {
      routers.memos = {
        rule = "Host(`memos.dezano.io`)";
        service = "memos";
        entryPoints = ["websecure"];
      };
      services.memos.loadBalancer.servers = [
        {url = "http://localhost:5230";}
      ];
    };
  };
  systemd.services."${config.virtualisation.oci-containers.backend}-memos" = {
    after = ["mnt-storage.mount"];
  };
}
