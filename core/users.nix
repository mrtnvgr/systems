{ user, ... }: {
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "disk" ];
    initialPassword = "password";
  };

  security.sudo.wheelNeedsPassword = false;
}
