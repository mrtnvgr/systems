{ pkgs, user, ... }: {
  environment.systemPackages = [ pkgs.android-tools ];
  users.users.${user}.extraGroups = [ "adbusers" ];
}
