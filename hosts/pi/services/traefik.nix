{config, ...}: {
  users.groups.www = {};
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "vinicius@myriad.codes";
      server = "https://localhost:8000/acme/acme/directory";
    };
  };
  services.traefik = {
    enable = true;
    group = config.users.groups.www.name;
    staticConfigOptions = {
      entrypoints = {
        web = {
          address = ":80";
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
          forwardedHeaders.trustedIPs = [
            "100.64.0.0/10"
            "192.168.1.0/24"
          ];
          http.tls.certResolver = "step-ca";
          http.tls.domains = [
            {
              main = "dezano.io";
              sans = ["*.dezano.io"];
            }
          ];
        };
      };
      certificatesResolvers = {
        step-ca.acme = {
          inherit (config.security.acme.defaults) email;
          caServer = config.security.acme.defaults.server;
          storage = "${config.services.traefik.dataDir}/acme.json";
          tlsChallenge = {};
        };
      };
    };
  };
  systemd.services.traefik.environment = {
    LEGO_CA_CERTIFICATES = config.sops.secrets."services/step-ca/root-cert".path;
  };
  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -p tcp --source 192.168.1.0/24 --dport 80,443 -j nixos-fw-accept
    iptables -A nixos-fw -p udp --source 192.168.1.0/24 --dport 80,443 -j nixos-fw-accept
  '';
  networking.firewall.extraStopCommands = ''
    iptables -D nixos-fw -p tcp --source 192.168.1.0/24 --dport 80,443 -j nixos-fw-accept || true
    iptables -D nixos-fw -p udp --source 192.168.1.0/24 --dport 80,443 -j nixos-fw-accept || true
  '';
}
