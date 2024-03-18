{ lib, config, user, ... }: {
  config = lib.mkIf config.modules.server.enable {
    # Disable wifi connections
    networking.useDHCP = false;
  };
}
