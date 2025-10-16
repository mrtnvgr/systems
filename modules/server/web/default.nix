{ lib, config, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.modules.server.web;
in {
  options.modules.server.web = {
    enable = mkEnableOption "web services";
    domain = mkOption { type = types.str; };
    master = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.master;
    };

    services.nginx = {
      enable = true;

      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedZstdSettings = true;
    };

	services.fail2ban.jails.nginx-bruteforce.settings = {
	  enabled = true;

      logpath = "/var/log/nginx/access.log";
	  backend = "auto";
	};

	environment.etc."fail2ban/filter.d/nginx-bruteforce.local".text = ''
	  [Definition]
      failregex = ^<HOST>.*GET.*(matrix/server|\.php|admin|wp\-|\.env|\.git).* HTTP/\d.\d\" 404.*$
    '';

	services.fail2ban.jails.nginx-ddos.settings = {
	  enabled = true;

      logpath = "/var/log/nginx/access.log";
	  backend = "auto";
	};

    environment.etc."fail2ban/filter.d/nginx-ddos.local".text = ''
      [Definition]
      failregex = ^<HOST> -.*"(GET|HEAD).*HTTP.*" (429|503)
    '';
  };

  imports = [
    ./eggs.nix
    ./redirects.nix
  ];
}
