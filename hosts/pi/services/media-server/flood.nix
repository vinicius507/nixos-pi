{
  lib,
  pkgs,
  ...
}: let
  port = 9192;
  stateDir = "flood";
in {
  systemd.services.flood = {
    description = "Flood torrent UI";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = lib.concatStringsSep " " [
        (lib.getExe pkgs.flood)
        "--port ${toString port}"
        "--rundir /var/lib/${stateDir}"
      ];
      DynamicUser = true;
      StateDirectory = stateDir;
      ReadWritePaths = "";
    };
  };
  services.traefik.dynamicConfigOptions = {
    http.routers.flood.rule = "Host(`flood.dezano.io`)";
    http.routers.flood.service = "flood";
    http.routers.flood.entryPoints = ["websecure"];
    http.routers.flood.tls = {};
    http.services.flood.loadBalancer.servers = [{url = "http://localhost:${toString port}";}];
  };
}
