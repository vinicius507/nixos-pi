{
  services.traefik = {
    enable = true;
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
        };
      };
    };
    dynamicConfigOptions = {
      tls.certificates = [
        {
          certFile = "/etc/ssl/certs/traefik/dezano.io.crt";
          keyFile = "/etc/ssl/certs/traefik/dezano.io.key";
        }
      ];
    };
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
