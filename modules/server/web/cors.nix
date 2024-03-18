{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.server.web.cors;
  domain = config.modules.server.web.domain;

  pancors = pkgs.buildGoModule {
    name = "pancors";
    vendorHash = null;

    src = pkgs.fetchFromGitHub {
      owner = "michaljanocko";
      repo = "pancors";
      rev = "177ce45fbce529826f8ddcde5e9b66848358d211";
      hash = "sha256-Ht2j2RdN8ZuqLGORX5irhg6e/AmEqDfQDhz/jEmI7Xs=";
    };
  };

  # Let's hope that its available
  port = "8818";
in {
  options.modules.server.web.cors.enable = mkEnableOption "cors proxy";

  config = mkIf cfg.enable {
    systemd.services.pancors = {
      description = "CORS Proxy";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        ALLOW_ORIGIN = "https://gg.${domain}";
        PORT = port;
      };

      serviceConfig = {
        Restart = "always";
        ExecStart = "${pancors}/bin/pancors";
      };
    };

    environment.systemPackages = [ pancors ];

    services.nginx.virtualHosts."cors.${domain}" = {
      locations."/".proxyPass = "http://localhost:${port}";

      enableACME = true;
      forceSSL = true;
    };
  };

  # TODO: fail2ban support, notifications on every usage?!
}
