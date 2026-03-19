{ lib, config, user, ... }: let
  desk = config.modules.desktop;
  enabled = desk.apps.neovim.enable && desk.dev.python.enable;
in {
  home-manager.users.${user}.programs.nixvim.plugins = lib.mkIf enabled {
    lsp.servers.basedpyright.enable = true;
  };
}
