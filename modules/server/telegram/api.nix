{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.server.telegram.api;
  flags = "--local --api-id=${cfg.api_id} --api-hash=${cfg.api_hash} --http-port ${toString cfg.port}";
  workdir = "/etc/telegram/api";
  service-user = "telegram-api";
in {
  options.modules.server.telegram.api = {
    enable = mkEnableOption "local telegram-bot-api instance";

    api_id = mkOption { type = types.str; };
    api_hash = mkOption { type = types.str; };

    port = mkOption {
      type = types.port;
      default = 8081;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.telegram-api = {
      enable = true;

      after = [ "network.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        User = service-user;
        Group = service-user;
        Type = "simple";
        NonBlocking = true;
        WorkingDirectory = workdir;
        ExecStart = "${pkgs.telegram-bot-api}/bin/telegram-bot-api ${flags}";
        ExecReload = "/bin/sh kill -HUP \${MAINPID}";
        ExecStop = "/bin/sh kill -INT \${MAINPID}";
        TimeoutSec = 30;
        Restart = "on-failure";
        RestartSec = "5s";
      };

      wantedBy = [ "multi-user.target" ];
    };

    users.groups.${service-user} = {};
    users.users.${service-user} = {
      group = service-user;
      isSystemUser = true;
    };

    systemd.tmpfiles.rules = [
      "d ${workdir} 0755 ${service-user} ${service-user}"
    ];
  };
}
