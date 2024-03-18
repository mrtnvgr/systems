{ inputs, lib, config, ... }:
let
  inherit (lib) mkOption mkEnableOption types mkIf;
  cfg = config.modules.server.email;
  domain = config.modules.server.web.domain;
in {
  imports = [ inputs.nixos-mailserver.nixosModule ];

  options.modules.server.email = {
    enable = mkEnableOption "email server";
    accounts = mkOption { type = types.attrs; };
  };

  # TODO: backups

  config = mkIf cfg.enable {
    mailserver = {
      enable = true;
      fqdn = "mail.${domain}";
      domains = [ domain ];

      loginAccounts = cfg.accounts;

      certificateScheme = "acme-nginx";
    };

	services.fail2ban.jails.postfix-bruteforce.settings = {
	  enabled = true;
	};

    environment.etc."fail2ban/filter.d/postfix-bruteforce.local".text = ''
      [Definition]
      failregex = warning: [\w\.\-]+\[<HOST>\]: SASL LOGIN authentication failed.*$
      journalmatch = _SYSTEMD_UNIT=postfix.service
    '';

    # FIXME: https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/issues/275
    services.dovecot2.sieve.extensions = [ "fileinto" ];
  };
}
