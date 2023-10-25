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
  services.nginx.virtualHosts."flood.dezano.io" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
    };
  };
}
