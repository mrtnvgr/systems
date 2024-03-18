{ lib, config, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    networking.networkmanager = {
      # Randomize MAC
      wifi.macAddress = "random";
    };

    # Allow general test ports
    networking.firewall.allowedTCPPorts = [ 8000 8080 ];

    systemd.services.NetworkManager-wait-online.enable = false;
    systemd.network.wait-online.enable = false;
  };
}
