{ lib, config, user, ... }: let
  desk = config.modules.desktop;
  enabled = desk.apps.neovim.enable && desk.dev.enable;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf enabled {
    lsp.servers.nixd.enable = true;
  };
}
