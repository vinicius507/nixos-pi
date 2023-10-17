{
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings = {
      bind_port = 3000;
      dns = {
        bind_hosts = ["0.0.0.0"];
        ratelimit = 100;
      };
    };
  };
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
  services.nginx.virtualHosts."adguard.dezano.io".locations."/" = {
    proxyPass = "http://127.0.0.1:3000";
  };
}
