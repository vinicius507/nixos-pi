{
  networking = {
    firewall = {
      enable = true;
      extraCommands = ''
        iptables -A INPUT -p tcp --destination-port 8000 -s 172.17.0.1/16 -j ACCEPT
      '';
    };
    nameservers = ["127.0.0.1"];
    networkmanager.enable = true;
  };
}
