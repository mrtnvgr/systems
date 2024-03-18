{ pkgs, lib, config, ... }:
let
  inherit (builtins) concatStringsSep;
  inherit (lib) mkIf mkOption types optionalString;

  cfg = config.modules.server;
  notificationsEnabled = cfg.ntfyChannel != null;
in {
  options.modules.server.ntfyChannel = mkOption {
    type = with types; nullOr (uniq str);
    default = null;
  };

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
          (optionalString notificationsEnabled "ntfy")
        ];

        findtime = "4h";
      };
    };

    # TODO: norestored does not work
    environment.etc."fail2ban/action.d/ntfy.local".text = optionalString notificationsEnabled ''
      [Definition]
      norestored = true # Needed to avoid receiving a new notification after every restart
      actionban = ${pkgs.curl}/bin/curl -H "Title: New ban! <name>: <ip>" -d "<name>: <ip> (x<failures>)" ntfy.sh/${cfg.ntfyChannel}
    '';

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
