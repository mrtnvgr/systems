{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.server.web.eggs;
  domain = config.modules.server.web.domain;

  eggs = pkgs.fetchzip {
    url = "https://github.com/mrtnvgr/eggs/releases/download/master/built.zip";
    hash = "sha256-agg//mf+EzblSKWLrrPMGiCv/lbNRXf6Vp6SP9z46Ww=";
  };
in {
  options.modules.server.web.eggs.enable = mkEnableOption "eggs";
  config = mkIf cfg.enable {
    services.nginx.virtualHosts."gg.${domain}" = {
      root = eggs;

      enableACME = true;
      forceSSL = true;
    };
  };
}
