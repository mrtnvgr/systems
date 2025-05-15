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
      rev = "d25f00060c558dd58306eada5c1ae761bb1ec34b";
      hash = "sha256-RsCGrLjplZVY9CqcwUiCI/7csrHNJRndQRXevzmhyq4=";
    };

    nativeBuildInputs = with pkgs; [ pkg-config ];
    buildInputs = with pkgs; [ openssl ];

    useFetchCargoVendor = true;
    cargoHash = "sha256-Bfu1VlhloIJQr8VTuMHF64UL3TUZ5VxP5ki/fkre67Q=";
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
