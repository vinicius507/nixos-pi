{config, ...}: let
  inherit (config.sops) secrets;
in {
  users.users.step-ca.extraGroups = ["www"];
  services.step-ca = {
    enable = true;
    address = "0.0.0.0";
    port = 8000;
    intermediatePasswordFile = secrets."services/step-ca/intermediate-password".path;
    settings = {
      dnsNames = ["ca.dezano.io" "host.docker.internal" "localhost"];
      root = secrets."services/step-ca/root-cert".path;
      crt = secrets."services/step-ca/intermediate-cert".path;
      key = secrets."services/step-ca/intermediate-key".path;
      db = {
        type = "badger";
        dataSource = "/var/lib/step-ca/db";
      };
      policy = {
        x509 = {
          dns = ["*.dezano.io"];
          ip = [
            "100.64.0.0/10"
            "172.17.0.0/16"
            "192.168.1.0/24"
          ];
        };
      };
      authority = {
        provisioners = [
          {
            name = "acme";
            type = "ACME";
          }
        ];
      };
    };
  };
  services.traefik.dynamicConfigOptions = {
    tcp.routers.step-ca.rule = "HostSNI(`ca.dezano.io`)";
    tcp.routers.step-ca.service = "step-ca";
    tcp.routers.step-ca.entryPoints = ["websecure"];
    tcp.routers.step-ca.tls.passthrough = true;
    tcp.services.step-ca.loadBalancer.servers = [
      {
        address = "${toString config.services.step-ca.address}:${toString config.services.step-ca.port}";
      }
    ];
  };
  sops.secrets = {
    "services/step-ca/root-cert" = {
      owner = config.users.users.step-ca.name;
      group = config.users.groups.www.name;
      mode = "0444";
      restartUnits = ["step-ca.service" "traefik.service" "docker-memos.service"];
    };
    "services/step-ca/intermediate-cert" = {
      owner = config.users.users.step-ca.name;
      group = config.users.users.step-ca.group;
      restartUnits = ["step-ca.service"];
    };
    "services/step-ca/intermediate-key" = {
      owner = config.users.users.step-ca.name;
      group = config.users.users.step-ca.group;
      restartUnits = ["step-ca.service"];
    };
    "services/step-ca/intermediate-password" = {
      owner = config.users.users.step-ca.name;
      group = config.users.users.step-ca.group;
      restartUnits = ["step-ca.service"];
    };
  };
}
