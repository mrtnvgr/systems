# Credits: https://github.com/nix-community/srvos/blob/main/nixos/server/default.nix

{ lib, config, user, ... }: {
  config = lib.mkIf config.modules.server.enable {
    # Notice this also disables --help for some commands such es nixos-rebuild
    documentation.enable = lib.mkDefault false;
    documentation.info.enable = lib.mkDefault false;
    documentation.man.enable = lib.mkDefault false;
    documentation.nixos.enable = lib.mkDefault false;

    # No need for fonts on a server
    fonts.fontconfig.enable = lib.mkDefault false;

    systemd.enableEmergencyMode = false;

    # Anti-freeze
    systemd.watchdog.runtimeTime = "20s";
    systemd.watchdog.rebootTime = "30s";
    systemd.sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';

    # use TCP BBR has significantly increased throughput and reduced latency for connections
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };
}
