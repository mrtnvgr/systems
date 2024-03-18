{ lib, config, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types;
  domain = config.modules.server.web.domain;
  cfg = config.modules.server.web.cdn;
in {
  options.modules.server.web.cdn = {
    enable = mkEnableOption "cdn service";

    cdnPath = mkOption {
      type = types.str;
      default = "/var/www/cdn";
    };
  };

  config = mkIf config.modules.server.web.cdn.enable {
    services.nginx.virtualHosts."cdn.${domain}" = {
      root = cfg.cdnPath;

      enableACME = true;
      forceSSL = true;
    };

    system.activationScripts.cdn-directory = lib.stringAfter [ "var" ] ''
      mkdir -p ${cfg.cdnPath}
      chmod 755 ${cfg.cdnPath}
    '';

	services.fail2ban.jails.cdn-bruteforce.settings = {
	  enabled = true;

      logpath = "/var/log/nginx/access.log";
	  backend = "auto";
	};

	environment.etc."fail2ban/filter.d/cdn-bruteforce.local".text = ''
	  [Definition]
      failregex = No such file or directory.* client: <HOST>,
	'';

    # TODO: sync with yandex disk (periodically)!
  };
}
