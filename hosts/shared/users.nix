{
  users.users.vini = {
    isNormalUser = true;
    initialPassword = "password"; # TODO: change to hashedPasswordFile
    extraGroups = [
      "media"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPWdo2yzi5UwwXnc96HOhSaZ/d2k8bvlXFP8msKGdhW"
    ];
  };
}
