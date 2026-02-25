{ lib, config, user, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim.plugins = lib.mkIf cfg.enable {
    lsp.servers.nixd.enable = true;
  };
}
