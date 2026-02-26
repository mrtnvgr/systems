{ config, user, lib, ... }: {
  config = lib.mkMerge [
    { networking.networkmanager.enable = true; }
    { users.users.${user}.extraGroups = [ "networkmanager" ]; }

    # https://wiki.nixos.org/wiki/NetworkManager#DNS_Management
    (lib.mkIf (config.networking.nameservers != []) {
      networking.networkmanager.dns = "none";
      networking.useDHCP = false;
      networking.dhcpcd.enable = false;
    })
  ];
}
