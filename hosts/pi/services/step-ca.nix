{config, ...}: {
  services.step-ca = {
    enable = true;
    address = "127.0.0.1";
    port = 8000;
    intermediatePasswordFile = config.sops.secrets."step-ca/intermediatePassword".path;
    settings = {
      dnsNames = ["localhost"];
      root = "/var/lib/step-ca/certs/root_ca.crt";
      crt = "/var/lib/step-ca/certs/intermediate_ca.crt";
      key = config.sops.secrets."step-ca/intermediateCaKey".path;
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
  sops.secrets."step-ca/intermediateCaKey" = {
    owner = config.users.users.step-ca.name;
    group = config.users.users.step-ca.group;
  };
  sops.secrets."step-ca/intermediatePassword" = {
    owner = config.users.users.step-ca.name;
    group = config.users.users.step-ca.group;
  };
}
