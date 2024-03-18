{ inputs, pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.server.web.eggs;
  domain = config.modules.server.web.domain;
in {
  options.modules.server.web.eggs.enable = mkEnableOption "eggs";
  config = mkIf cfg.enable {
    services.nginx.virtualHosts."gg.${domain}" = {
      root = "${inputs.eggs}";

      enableACME = true;
      forceSSL = true;
    };
  };
}
