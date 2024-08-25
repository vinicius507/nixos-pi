{config, ...}: {
  virtualisation.oci-containers.containers.ntfy = {
    image = "binwiederhier/ntfy:v2.11.0@sha256:e46bd45887533598d5c1b7a2ac29cc1d93207397607aa8aa234d2b8e465ee2e8";
    cmd = ["serve"];
    volumes = [
      "/mnt/storage/data/ntfy:/var/lib/ntfy"
      "/mnt/storage/cache/ntfy:/var/cache/ntfy"
    ];
    ports = ["127.0.0.1:3001:80"];
    environment = {
      TZ = "America/Sao_Paulo";
      NTFY_BASE_URL = "https://ntfy.dezano.io";
      NTFY_AUTH_FILE = "/var/lib/ntfy/auth.db";
      NTFY_CACHE_FILE = "/var/lib/ntfy/cache.db";
      NTFY_AUTH_DEFAULT_ACCESS = "deny-all";
      NTFY_ATTACHMENTS_CACHE_DIR = "/var/cache/ntfy/attachments";
      NTFY_BEHIND_PROXY = "true";
      NTFY_ENABLE_LOGIN = "true";
    };
  };
  services.traefik.dynamicConfigOptions = {
    http = {
      routers.ntfy = {
        rule = "Host(`ntfy.dezano.io`)";
        service = "ntfy";
        entryPoints = ["websecure"];
      };
      services.ntfy.loadBalancer.servers = [
        {url = "http://localhost:3001";}
      ];
    };
  };
  systemd.services."${config.virtualisation.oci-containers.backend}-ntfy" = {
    after = ["mnt-storage.mount"];
  };
}
