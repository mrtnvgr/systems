{ user, ... }: {
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "disk" "dialout" ];
    initialPassword = "password";
  };

  security.sudo.wheelNeedsPassword = false;
}
