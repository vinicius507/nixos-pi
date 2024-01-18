{config, ...}: {
  services.outline = {
    enable = true;
    secretKeyFile = config.sops.secrets."services/outline/secret-key".path;
    utilsSecretFile = config.sops.secrets."services/outline/utils-secret".path;
    publicUrl = "https://notes.dezano.io";
    port = 3001;
    storage = {
      storageType = "local";
      localRootDir = "/mnt/storage/data/outline";
    };
    oidcAuthentication = let
      oidcUrl = "https://auth.dezano.io/realms/dezano/protocol/openid-connect";
    in {
      clientId = "outline-oidc";
      clientSecretFile = config.sops.secrets."services/outline/oidc-client-secret".path;
      authUrl = "${oidcUrl}/auth";
      tokenUrl = "${oidcUrl}/token";
      userinfoUrl = "${oidcUrl}/userinfo";
    };
  };
  services.traefik.dynamicConfigOptions = {
    http = {
      routers.outline = {
        rule = "Host(`notes.dezano.io`)";
        service = "outline";
        entryPoints = ["websecure"];
      };
      services.outline.loadBalancer.servers = [
        {url = "http://localhost:${toString config.services.outline.port}";}
      ];
    };
  };
  sops.secrets = {
    "services/outline/secret-key" = {
      owner = config.services.outline.user;
      group = config.services.outline.group;
    };
    "services/outline/utils-secret" = {
      owner = config.services.outline.user;
      group = config.services.outline.group;
    };
    "services/outline/oidc-client-secret" = {
      owner = config.services.outline.user;
      group = config.services.outline.group;
    };
  };
}
