{ pkgs, lib, config, ... }: let
  cfg = config.modules.generic.services.tor;
in {
  options.modules.generic.services.tor = {
    enable = lib.mkEnableOption "Enable Tor service";

    bridges = lib.mkOption {
      type = with lib.types; listOf singleLineStr;
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    services.tor = {
      enable = true;
      torsocks.enable = config.modules.desktop.enable;

      settings = {
        UseBridges = cfg.bridges != [];
        Bridge = cfg.bridges;
        ClientTransportPlugin = "webtunnel exec ${pkgs.webtunnel}/bin/client";

        SOCKSPort = [ { port = 9050; } ];
      };
    };
  };
}
