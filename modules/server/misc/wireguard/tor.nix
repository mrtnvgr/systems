{ pkgs, lib, config, ... }:
let
  cfg = config.modules.server.misc.wireguard;
in {
  options.modules.server.misc.wireguard.tor = {
    enable = lib.mkEnableOption "Route all traffic through Tor";
    bridges = lib.mkOption {
      type = with lib.types; listOf singleLineStr;
    };
  };

  config = lib.mkIf cfg.tor.enable {
    services.tor = {
      enable = true;
      enableGeoIP = false;

      client.enable = true;

      settings = {
        UseBridges = true;
        ClientTransportPlugin = "webtunnel exec ${pkgs.webtunnel}/bin/client";

        TransPort = [ { addr = "127.0.0.1"; port = 9040; } ];

        Bridge = cfg.tor.bridges;
      };
    };

    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };

    networking.nftables = {
      enable = true;

      ruleset = let
        getPort = x: toString ((builtins.elemAt config.services.tor.settings."${x}" 0).port);
      in ''
        table inet torredir {
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;
            iifname "wg0" meta l4proto tcp redirect to :${getPort "TransPort"}
          }
        }
      '';
    };
  };
}
