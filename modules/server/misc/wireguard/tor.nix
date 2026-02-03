{ pkgs, lib, config, ... }:
let
  cfg = config.modules.server.misc.wireguard;
  iptables = "${pkgs.iptables}/bin/iptables";
in {
  options.modules.server.misc.wireguard.tor = {
    enable = lib.mkEnableOption "Route all traffic through Tor";
    bridges = lib.mkOption {
      type = with lib.types; listOf singleLineStr;
      default = [];
    };
  };

  config = lib.mkIf cfg.tor.enable {
    services.tor = {
      enable = true;
      enableGeoIP = false;

      settings = {
        UseBridges = cfg.tor.bridges != [];
        Bridge = cfg.tor.bridges;
        ClientTransportPlugin = "webtunnel exec ${pkgs.webtunnel}/bin/client";

        TransPort = [ { addr = "10.1.2.1"; port = 9040; } ];

        DNSPort = [ { addr = "10.1.2.1"; port = 9053; } ];
        AutomapHostsOnResolve = true;
      };
    };

    networking.wg-quick.interfaces.wg0 = {
      postUp = ''
        ${iptables} -t nat -A PREROUTING -i %i -p tcp --syn -j REDIRECT --to-ports 9040
        ${iptables} -t nat -A PREROUTING -i %i -p udp --dport 53 -j REDIRECT --to-ports 9053
        ${iptables} -A INPUT -i %i -p tcp --dport 9040 -j ACCEPT
        ${iptables} -A INPUT -i %i -p udp --dport 9053 -j ACCEPT
        ${iptables} -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
        ${iptables} -A FORWARD -i %i -p udp -j DROP
        ${iptables} -t nat -A POSTROUTING -o ${cfg.publicInterface} -j MASQUERADE
      '';

      postDown = ''
        ${iptables} -t nat -D POSTROUTING -o ${cfg.publicInterface} -j MASQUERADE
        ${iptables} -D FORWARD -i %i -p udp -j DROP
        ${iptables} -D FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
        ${iptables} -D INPUT -i %i -p udp --dport 9053 -j ACCEPT
        ${iptables} -D INPUT -i %i -p tcp --dport 9040 -j ACCEPT
        ${iptables} -t nat -D PREROUTING -i %i -p udp --dport 53 -j REDIRECT --to-ports 9053
        ${iptables} -t nat -D PREROUTING -i %i -p tcp --syn -j REDIRECT --to-ports 9040
      '';
    };
  };
}
