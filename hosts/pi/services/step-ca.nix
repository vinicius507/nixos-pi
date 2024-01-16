{config, ...}: let
  inherit (config.sops) secrets;
in {
  users.users.step-ca.extraGroups = ["www"];
  services.step-ca = {
    enable = true;
    address = "127.0.0.1";
    port = 8000;
    intermediatePasswordFile = secrets."services/step-ca/intermediate-password".path;
    settings = {
      dnsNames = ["ca.dezano.io" "localhost"];
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
  sops.secrets = {
    "services/step-ca/root-cert" = {
      owner = config.users.users.step-ca.name;
      group = config.users.groups.www.name;
      mode = "0440";
      restartUnits = ["step-ca.service" "traefik.service"];
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
