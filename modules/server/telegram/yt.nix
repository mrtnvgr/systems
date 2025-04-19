{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;

  cfg = config.modules.server.telegram.yt;
  api_cfg = config.modules.server.telegram.api;

  workdir = "/etc/telegram/yt";
  service-user = "telegram-yt";

  pkg = pkgs.rustPlatform.buildRustPackage {
    pname = "yt-tg";
    version = "0.1.0-dev";

    # src = pkgs.fetchFromGitHub {
    #   owner = "mrtnvgr";
    #   repo = "yt-tg";
    #   rev = "TODO";
    #   hash = "";
    # };
    src = /home/user/yt-tg;

    nativeBuildInputs = with pkgs; [ pkg-config ];
    buildInputs = with pkgs; [ openssl ];

    ADMIN_ID = toString cfg.adminId;

    # useFetchCargoVendor = true;
    # cargoHash = "sha256-wQ01AVn5C52GCEACF0de5uPGFpKGjmWJHfw+Oc0Ln/s=";
    cargoLock.lockFile = /home/user/yt-tg/Cargo.lock;
  };
in {
  options.modules.server.telegram.yt = {
    enable = mkEnableOption "media downloader telegram bot";

    token = mkOption {
      type = types.str;
    };

    adminId = mkOption {
      type = types.int;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.telegram-yt = {
      enable = true;

      after = [ "network.target" "telegram-api.service" ];
      requires = [ "network-online.target" "telegram-api.service" ];

      environment = {
        RUST_LOG = "INFO";
        WORKDIR = workdir;

        TELOXIDE_API_URL = mkIf api_cfg.enable "http://0.0.0.0:${toString api_cfg.port}";
        TELOXIDE_TOKEN = cfg.token;
      };

      serviceConfig = {
        User = service-user;
        Group = service-user;
        Type = "simple";
        NonBlocking = true;
        WorkingDirectory = workdir;
        ExecStart = "${pkg}/bin/yt-tg";
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
