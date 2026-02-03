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
        ${iptables} -A -t nat PREROUTING -i wg0 -p udp --dport 53 -j DNAT --to-destination 127.0.0.2:9053
        ${iptables} -A -t nat PREROUTING -i wg0 -p tcp -j DNAT --to-destination 127.0.0.2:9040
        ${iptables} -A -t nat PREROUTING -i wg0 -p udp -j DNAT --to-destination 127.0.0.2:9040
        ${iptables} -A OUTPUT -o ${cfg.publicInterface} -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j ACCEPT
        ${iptables} -A OUTPUT -t nat -d 10.192.0.0/10 -p tcp -m tcp -j DNAT --to-destination 127.0.0.2:9040
        ${iptables} -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
        ${iptables} -A OUTPUT -m conntrack --ctstate INVALID -j DROP
        ${iptables} -A OUTPUT -m state --state INVALID -j DROP
        ${iptables} -A OUTPUT -t nat -o lo -j RETURN
        ${iptables} -A OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,FIN ACK,FIN -j DROP
        ${iptables} -A OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,RST ACK,RST -j DROP
      '';

      postDown = ''
        ${iptables} -D -t nat PREROUTING -i wg0 -p udp --dport 53 -j DNAT --to-destination 127.0.0.2:9053
        ${iptables} -D -t nat PREROUTING -i wg0 -p tcp -j DNAT --to-destination 127.0.0.2:9040
        ${iptables} -D -t nat PREROUTING -i wg0 -p udp -j DNAT --to-destination 127.0.0.2:9040
        ${iptables} -D OUTPUT -o ${cfg.publicInterface} -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j ACCEPT
        ${iptables} -D OUTPUT -t nat -d 10.192.0.0/10 -p tcp -m tcp -j DNAT --to-destination 127.0.0.2:9040
        ${iptables} -D OUTPUT -m state --state ESTABLISHED -j ACCEPT
        ${iptables} -D OUTPUT -m conntrack --ctstate INVALID -j DROP
        ${iptables} -D OUTPUT -m state --state INVALID -j DROP
        ${iptables} -D OUTPUT -t nat -o lo -j RETURN
        ${iptables} -D OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,FIN ACK,FIN -j DROP
        ${iptables} -D OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,RST ACK,RST -j DROP
      '';
    };
  };
}
