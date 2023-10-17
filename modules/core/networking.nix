{config, ...}: {
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [
        config.services.tailscale.interfaceName
      ];
    };
  };
  services.tailscale.enable = true;
}
