{
  services.sonarr.enable = true;
  users.users.sonarr = {
    extraGroups = ["media"];
  };
  systemd.services.sonarr = {
    serviceConfig.UMask = "0007";
  };
  services.nginx.virtualHosts."sonarr.dezano.io" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8989";
    };
  };
}
