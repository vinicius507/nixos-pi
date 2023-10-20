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
}
