{ lib, config, user, ... }:
let
  inherit (lib) types mkEnableOption mkOption mkIf;
  cfg = config.modules.generic.sshd;
in {
  options.modules.generic.sshd = {
    enable = mkEnableOption "enable sshd";
    keys = mkOption { type = types.listOf types.str; };
    enablePasswordAuthImReallySure = mkEnableOption "enable sshd connections by password";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = cfg.enable;
      settings = {
        PasswordAuthentication = cfg.enablePasswordAuthImReallySure;
        PermitRootLogin = "no";
      };
    };

    users.users.${user}.openssh.authorizedKeys.keys = cfg.keys;
  };
}
