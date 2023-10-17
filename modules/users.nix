{
  users.users.vini = {
    isNormalUser = true;
    initialPassword = "password"; # TODO: change to hashedPasswordFile
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhSMRMlnqNZ8VlxE+fGiCkiGpl7X6etvtjBtkZvZfnP"
    ];
  };
}
