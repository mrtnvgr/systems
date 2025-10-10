{ user, ... }: {
  users.users.${user}.extraGroups = [ "kvm" ];
}
