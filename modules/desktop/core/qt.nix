{ lib, config, user, ... }: let
  cfg = config.modules.desktop;
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    qt.enable = true;
  };
}
