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
          http.tls.certificates = [
            {
              certFile = "/etc/ssl/certs/traefik/dezano.io.crt";
              keyFile = "/etc/ssl/certs/traefik/dezano.io.key";
            }
          ];
        };
      };
    };
  };
}
