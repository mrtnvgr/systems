{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;

  cfg = config.modules.server.telegram.yt;
  api_cfg = config.modules.server.telegram.api;

  workdir = "/etc/telegram/yt";
  service-user = "telegram-yt";

  pkg = pkgs.rustPlatform.buildRustPackage {
    pname = "yttg";
    version = "0.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "mrtnvgr";
      repo = "yttg";
      rev = "b2a199164de52f9be1d0c2a9bff1fb377b9fcc49";
      hash = "sha256-VHrMPX8fpi7DPXUiYnx0hykHQltCp1/uP5SNO8mP/j8=";
    };

    nativeBuildInputs = with pkgs; [ pkg-config ];
    buildInputs = with pkgs; [ openssl ];

    useFetchCargoVendor = true;
    cargoHash = "sha256-IuK2XWYHEwfnCHvkr2oY/NCnduPtdf8nVCew5LoWnwY=";
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

        ADMIN_ID = toString cfg.adminId;
      };

      serviceConfig = {
        User = service-user;
        Group = service-user;
        Type = "simple";
        NonBlocking = true;
        WorkingDirectory = workdir;
        ExecStart = "${pkg}/bin/yttg";
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
