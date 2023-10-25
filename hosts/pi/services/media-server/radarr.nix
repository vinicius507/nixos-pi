{
  services.radarr.enable = true;
  users.users.radarr = {
    extraGroups = ["media"];
  };
  systemd.services.radarr = {
    serviceConfig.UMask = "0007";
  };
  services.nginx.virtualHosts."radarr.dezano.io" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:7878";
    };
  };
}
