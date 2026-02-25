{ lib, config, user, ... }: let
  cfg = config.modules.desktop.dev.rust;
in {
  home-manager.users.${user}.programs.nixvim.plugins = lib.mkIf cfg.enable {
    lsp.servers.nixd.enable = true;
  };
}
