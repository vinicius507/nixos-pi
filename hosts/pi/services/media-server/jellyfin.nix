{lib, ...}: {
  services.jellyfin = {
    enable = true;
    group = "media";
  };
  services.nginx.virtualHosts."jellyfin.dezano.io" = {
    extraConfig = ''
      client_max_body_size 20M;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096";
    };
  };
  systemd.services.jellyfin.serviceConfig.UMask = lib.mkForce "0007";
}
