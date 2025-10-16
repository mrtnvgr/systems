{ lib, config, ... }:
let
  inherit (builtins) concatStringsSep;
  inherit (lib) mkIf;

  cfg = config.modules.server;
in {
  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      bantime = "24h";

      bantime-increment = {
        enable = true;
        rndtime = "5m";
      };

      jails.DEFAULT.settings = {
        action = concatStringsSep "\n         " [
          "%(action_)s[blocktype=DROP]"
        ];

        findtime = "4h";
      };
    };

    # TODO: Auto restart
    # FIXME: https://github.com/NixOS/nixpkgs/issues/288436
    # systemd.services."fail2ban".restartTriggers = [ ];

    # TODO: enable some of these
    # etc/fail2ban/filter.d/nginx-bad-request.conf
    # etc/fail2ban/filter.d/nginx-botsearch.conf
    # etc/fail2ban/filter.d/nginx-http-auth.conf
    # etc/fail2ban/filter.d/nginx-limit-req.conf
    # etc/fail2ban/filter.d/postfix.conf
    # etc/fail2ban/filter.d/sendmail-auth.conf
    # etc/fail2ban/filter.d/sendmail-reject.conf
  };
}
