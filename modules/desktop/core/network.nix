{ lib, config, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    networking.networkmanager = {
      # Randomize MAC
      wifi.macAddress = "random";
    };

    systemd.services.NetworkManager-wait-online.enable = false;
    systemd.network.wait-online.enable = false;
  };
}
