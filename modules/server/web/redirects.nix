{ lib, config, ... }: let
  inherit (lib) mkOption mkIf types;
  inherit (builtins) mapAttrs;

  cfg = config.modules.server.web;
in {
  options.modules.server.web.redirects = mkOption {
    type = with types; attrsOf str;
  };

  config = mkIf (cfg.redirects != {}) {
    services.nginx.virtualHosts."s.${cfg.domain}" = {
      locations = mapAttrs (name: url: { return = "301 ${url}"; }) cfg.redirects;

      enableACME = true;
      forceSSL = true;
    };
  };
}
