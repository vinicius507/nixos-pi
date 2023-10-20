{
  # TODO: change sshd ports
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = false;
    };
  };
}
