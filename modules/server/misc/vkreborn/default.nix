{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.server.misc.vkreborn;
in {
  options.modules.server.misc.vkreborn = {
    enable = mkEnableOption "vkreborn";
    env = mkOption { type = types.path; };
    dbPath = mkOption { type = types.str; };
    dbEnv = mkOption { type = types.path; };
  };

  config = mkIf cfg.enable {
    system.activationScripts.mkVkRNetwork = ''
      ${pkgs.docker}/bin/docker network create vkreborn &2>/dev/null || true
    '';

    virtualisation.oci-containers.backend = "docker";
    virtualisation.oci-containers.containers = {
      vkreborn = {
        image = "ghcr.io/mrtnvgr/vkreborn";
        environment.POSTGRES_HOST = "vkrdb";
        environmentFiles = [ cfg.env cfg.dbEnv ];
        dependsOn = [ "vkrdb" ];
        extraOptions = [ "--network=vkreborn" ];
      };

      vkrdb = {
        image = "postgres:15-alpine";
        environmentFiles = [ cfg.dbEnv ];
        environment.POSTGRES_DB = "vkreborn";
        environment.PGDATA = "/var/lib/postgres/data/pgdata";
        volumes = [ "${cfg.dbPath}:/var/lib/postgres/data" ];
        extraOptions = [ "--network=vkreborn" ];
      };
    };

    # TODO: backups (restic?)

    # Skip systemd service restarts on switch
    systemd.services."docker-vkreborn".restartIfChanged = false;
    systemd.services."docker-vkrdb".restartIfChanged = false;
  };
}
