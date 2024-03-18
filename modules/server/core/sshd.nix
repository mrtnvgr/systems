{ lib, config, user, ... }: {
  config = lib.mkIf config.modules.server.enable {
    services.openssh = {
      enable = config.modules.server.sshKeys != [ ];
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    users.users.${user}.openssh.authorizedKeys.keys = config.modules.server.sshKeys;
  };
}
