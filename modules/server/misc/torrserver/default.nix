{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types optionalString;
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

  webIsSupported = config.modules.server.web.enable;
  domain = config.modules.server.web.domain;

  hasUsers = cfg.users != {};
  flags = "--port ${toString cfg.port} ${optionalString hasUsers "-a"}";
in {
  options.modules.server.misc.torrserver = {
    enable = mkEnableOption "torrserver";

    port = mkOption {
      type = types.port;
      default = 8090;
    };

    expose = mkEnableOption "expose torrserver in firewall";

    users = mkOption {
      type = types.attrsOf types.str;
      default = {};
    };
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
        WorkingDirectory = "/etc/torrserver";
        ExecStart = "${pkg}/bin/torrserver ${flags}";
        ExecReload = "/bin/sh kill -HUP \${MAINPID}";
        ExecStop = "/bin/sh kill -INT \${MAINPID}";
        TimeoutSec = 30;
        Restart = "on-failure";
        RestartSec = "5s";
        # StateDirectory = "torrserver";
      };

      wantedBy = [ "multi-user.target" ];
    };

    users.groups.torrserver = {};
    users.users.torrserver = {
      group = "torrserver";
      isSystemUser = true;
    };

    systemd.tmpfiles.rules = [
      "d /etc/torrserver 0755 torrserver torrserver"
    ];

    environment.etc."torrserver/accs.db".text = mkIf hasUsers (builtins.toJSON cfg.users);

    networking.firewall.allowedTCPPorts = mkIf cfg.expose [ cfg.port ];
    networking.firewall.allowedUDPPorts = mkIf cfg.expose [ cfg.port ];

    services.nginx.virtualHosts."ts.${domain}" = mkIf webIsSupported {
      locations."/".proxyPass = "http://localhost:${toString cfg.port}";

      enableACME = true;
      forceSSL = true;
    };
  };
}
