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

  has_users = cfg.users != {};
  flags = "--port ${cfg.port} ${optionalString has_users "-a"}";
in {
  options.modules.server.misc.torrserver = {
    enable = mkEnableOption "torrserver";

    port = mkOption {
      type = types.port;
      default = 8090;
    };

    expose = mkEnableOption "expose torrserver in firewall";

    users = mkOption {
      type = types.attrsOf types.string;
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
        WorkingDirectory = "/var/lib/torrserver";
        ExecStart = "${pkg}/bin/torrserver ${flags}";
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

    networking.firewall.allowedTCPPorts = mkIf cfg.expose [ cfg.port ];

    file."/var/lib/torrserver".text = mkIf has_users builtins.toJSON cfg.users;
  };
}
