{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.server.misc.telegram-api;

  domain = config.modules.server.web.domain;

  flags = "--local --api-id=\"${cfg.api_id}\" --api-hash=\"${cfg.api_hash}\" --http-port ${toString cfg.port} --dir=/tmp/";
in {
  options.modules.server.misc.telegram-api = {
    enable = mkEnableOption "torrserver";

    api_id = mkOption {
      type = types.str;
    };

    api_hash = mkOption {
      type = types.str;
    };

    port = mkOption {
      type = types.port;
      default = 8081;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.torrserver = {
      enable = true;

      path = with pkgs; [ telegram-bot-api ];

      after = [ "network.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        # User = "telegram-api";
        # Group = "telegram-api";
        User = "nobody";
        Group = "nogroup";
        Type = "simple";
        NonBlocking = true;
        WorkingDirectory = "/etc/telegram-api";
        ExecStart = "telegram-bot-api ${flags}";
        ExecReload = "/bin/sh kill -HUP \${MAINPID}";
        ExecStop = "/bin/sh kill -INT \${MAINPID}";
        TimeoutSec = 30;
        Restart = "on-failure";
        RestartSec = "5s";
      };

      wantedBy = [ "multi-user.target" ];
    };

    # users.groups.telegram-api = {};
    # users.users.telegram-api = {
    #   group = "telegram-api";
    #   isSystemUser = true;
    # };
    #
    # systemd.tmpfiles.rules = [
    #   "d /etc/telegram-api 0755 telegram-api telegram-api"
    # ];
  };
}
