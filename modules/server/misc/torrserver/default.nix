{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.server.misc.torrserver;

  pkg = pkgs.stdenv.mkDerivation rec {
    pname = "torrserver";
    version = "130";

    src = pkgs.fetchurl {
      url = "https://github.com/YouROK/TorrServer/releases/download/MatriX.${version}/TorrServer-linux-amd64";
      hash = "sha256-oUoa+/3GI4dx2qqJI4A3K1tSUeZnXTyeud5Zfg7rJag=";
    };

    nativeBuildInputs = with pkgs; [ autoPatchelfHook ];

    phases = "installPhase";
    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/torrserver
      runHook postInstall
    '';
  };
in {
  options.modules.server.misc.torrserver = {
    enable = mkEnableOption "torrserver";
  };

  config = mkIf cfg.enable {
    systemd.services.torrserver = {
      enable = true;

      path = with pkgs; [ ffmpeg-full ];

      after = [ "network.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        User = "torrserver";
        Group = "torrserver";
        Type = "simple";
        NonBlocking = true;
        # EnvironmentFile = "$dirInstall/$serviceName.config"
        WorkingDirectory = "/var/lib/torrserver";
        ExecStart = "${pkg}/bin/torrserver";
        ExecReload = "/bin/sh kill -HUP \${MAINPID}";
        ExecStop = "/bin/sh kill -INT \${MAINPID}";
        TimeoutSec = 30;
        Restart = "on-failure";
        RestartSec = "5s";
      };

      wantedBy = [ "multi-user.target" ];
    };

    system.activationScripts.torrserver = lib.stringAfter [ "var" ] ''
      mkdir -p /var/lib/torrserver
      chown -R torrserver:torrserver /var/lib/torrserver
    '';

    users.groups.torrserver = {};
    users.users.torrserver = {
      group = "torrserver";
      isSystemUser = true;
    };
  };
}
